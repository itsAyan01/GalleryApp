//
//  PhotosViewModel.swift
//  PhotoGalleryApp
//
//  Created by Ayan Ansari on 26/07/23.
//

import Foundation
import Photos
import UIKit

struct ImageModel: Hashable {
    let urlStr: String
}

final class PhotosViewModel: ObservableObject {
    
    @Published var allPhotos: PHFetchResult<PHAsset>? = nil
    @Published var images = [UIImage]()
    
    func requestForPhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                self.getPhotos()
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            case .limited:
                print("Not determined yet")
            @unknown default:
                print("Not determined yet")
            }
        }
    }
    
    fileprivate func getPhotos() {
        
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        // .highQualityFormat will return better quality photos
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if results.count > 0 {
            for i in 0..<results.count {
                let asset = results.object(at: i)
                let size = CGSize(width: 700, height: 700)
                manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { [weak self] (image, _) in
                    if let image = image {
                        self?.images.append(image)
                    } else {
                        print("error asset to image")
                    }
                }
            }
        } else {
            print("no photos to display")
        }
        
    }
}
