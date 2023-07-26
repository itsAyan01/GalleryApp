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
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text("X")
                    .font(.largeTitle)
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
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(imgArray.enumerated()), id: \.offset) { index, image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .onTapGesture {
                                withAnimation {
                                    selectedImage = index
                                }
                            }
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
