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
        GridItem(.flexible(), spacing: 8, alignment: nil),
        GridItem(.flexible(), spacing: 8, alignment: nil),
        GridItem(.flexible(), spacing: 8, alignment: nil)
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
        .onAppear { viewModel.requestForPhotos() }
    }
}

// MARK: Sub View's
extension PhotosView {
    var gridView: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: column, spacing: 8) {
                    ForEach(Array(viewModel.images.enumerated()), id: \.offset) { index, image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 100)
                            .frame(width: UIScreen.main.bounds.width / 3.1)
                            .onTapGesture {
                                withAnimation {
                                    selectedImage = index
                                    showFullScreenView = true
                                }
                            }
                            .clipShape(Rectangle())
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
        .alert("Permission Required", isPresented: $viewModel.isPermissionDenied) {
            Button("Cancel", role: .cancel) { }
            Button("Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text("Please allow photos permission from settings.")
        }
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView()
    }
}
