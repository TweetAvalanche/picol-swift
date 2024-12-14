//
//  ImageViewModel.swift
//  picol
//

import Foundation
import UIKit

class ImageViewModel: ObservableObject {
    @Published var isLoading = false

    let characterAPI = CharacterAPI()
    private let keychain = KeychainManager.shared

    func uploadImage(image: UIImage, completion: @escaping (String?) -> Void) {
        print("uploadImage")
        
        isLoading = true
        
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        guard let uid = keychain.load(key: "uid") else {
            print("uid not found")
            completion(nil)
            return
        }
        

        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("image.jpg")

        do {
            try data.write(to: fileURL)
        } catch {
            print("Failed to write image data")
            completion(nil)
            return
        }

        characterAPI.postCharacter(uid: uid, fileURL: fileURL) { [weak self] result in
            DispatchQueue.main.async {
                print("upload image...")
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    print("upload image success")
                    print(user)
                case .failure(let error):
                    print("upload image failure")
                    print(error)
                }
                self.isLoading = false
            }
        }
    }
}
