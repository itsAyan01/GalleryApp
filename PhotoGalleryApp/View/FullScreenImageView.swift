//
//  FullScreenImageView.swift
//  PhotoGalleryApp
//
//  Created by Ayan Ansari on 26/07/23.
//

import SwiftUI

struct FullScreenImageView: View {
    
    let namespace: Namespace.ID
    var imgArray: [UIImage]
    @Binding var selectedImage: Int
    @Binding var showFullScreenView: Bool
    @State private var dragOffset = CGSize.zero
    @State private var scaleAmount: CGFloat = 0
    @Namespace var selectedImageNamespace
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Image(systemName: "x.circle.fill")
                    .font(.title)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        withAnimation {
                            showFullScreenView = false
                        }
                    }
            }
            .padding()
            
            TabView(selection: $selectedImage) {
                ForEach(Array(imgArray.enumerated()), id:\.offset) { index, image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .scaleEffect(scaleAmount + 1)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    withAnimation(.linear) {
                                        scaleAmount = value - 1
                                    }
                                }
                                .onEnded { value in
                                    withAnimation(.spring()) {
                                        scaleAmount = 0
                                    }
                                }
                        )
                        .onTapGesture(count: 2) {
                            doubleTapped()
                        }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .offset(y: dragOffset.height)
            .gesture(
                DragGesture()
                    .onChanged { newValue in
                        withAnimation {
                            self.dragOffset = newValue.translation
                        }
                    }
                    .onEnded { newValue in
                        if newValue.translation.height >= 250 || newValue.translation.height <= -250 {
                            withAnimation {
                                showFullScreenView = false
                            }
                        } else {
                            withAnimation {
                                self.dragOffset = .zero
                            }
                        }
                    }
            )
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(imgArray.enumerated()), id: \.offset) { index, image in
                            VStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 60)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedImage = index
                                        }
                                    }
                                
                                if selectedImage == index {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: 80, height: 2)
                                        .matchedGeometryEffect(id: "1", in: selectedImageNamespace)
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    proxy.scrollTo(selectedImage, anchor: .leading)
                }
                .onChange(of: selectedImage) { newValue in
                    withAnimation {
                        proxy.scrollTo(newValue)
                    }
                }
            }
        }
    }
    
    private func doubleTapped() {
        if scaleAmount > 0 {
            withAnimation {
                scaleAmount = 0
            }
        } else {
            withAnimation {
                scaleAmount = 0.5
            }
        }
    }
}
