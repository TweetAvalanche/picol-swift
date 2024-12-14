//
//  ImageViewModel.swift
//  picol
//

import Foundation
import UIKit

class ImageViewModel: ObservableObject {
    func uploadImage(image: UIImage, completion: @escaping (String?) -> Void) {
        print("uploadImage")
        let imageAPI = ImageAPI()
        imageAPI.uploadImage(image: image) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    print("url: \(url)")
                    completion(url)
                case .failure(let error):
                    print("error: \(error)")
                    completion(nil)
                }
            }
        }
    }
}
