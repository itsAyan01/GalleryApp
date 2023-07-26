//
//  PhotosView.swift
//  PhotoGalleryApp
//
//  Created by Ayan Ansari on 26/07/23.
//

import SwiftUI

struct PhotosView: View {
    
    @StateObject var viewModel = PhotosViewModel()
    let column: [GridItem] = [
        GridItem(.flexible(), spacing: nil, alignment: nil),
        GridItem(.flexible(), spacing: nil, alignment: nil),
        GridItem(.flexible(), spacing: nil, alignment: nil)
    ]
    @State var imgUrls: [ImageModel] = []
    @State var selectedImage: Int = 0
    @State var showFullScreenView: Bool = false
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            if showFullScreenView {
                FullScreenImageView(namespace: namespace,
                                    imgArray: viewModel.images,
                                    selectedImage: $selectedImage,
                                    showFullScreenView: $showFullScreenView)
                .matchedGeometryEffect(id: "scaleTo\(selectedImage)", in: namespace)
            } else {
                gridView
            }
        }
        .onAppear {
            viewModel.requestForPhotos()
        }
    }
}

// MARK: Sub View's
extension PhotosView {
    var gridView: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: column) {
                    ForEach(Array(viewModel.images.enumerated()), id: \.offset) { index, image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .onTapGesture {
                                withAnimation {
                                    selectedImage = index
                                    showFullScreenView = true
                                }
                            }
                            .matchedGeometryEffect(id: "scaleTo\(index)", in: namespace)
                            .contextMenu {
                                Button {
                                    print("Change country setting")
                                } label: {
                                    Label("Add to fav", systemImage: "heart.fill")
                                }

                                Button(role: .destructive) {
                                    print("Enable geolocation")
                                } label: {
                                    Label("Detect", systemImage: "trash")
                                }
                            }
                    }
                }
            }
        }

    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView()
    }
}
