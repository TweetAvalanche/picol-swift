//
//  CharacterViewModel.swift
//  picol
//

import Foundation
import UIKit

class CharacterViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var user: User?

    let characterAPI = CharacterAPI()
    private let keychain = KeychainManager.shared

    func uploadImage(image: UIImage, completion: @escaping (User?) -> Void) {
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
                    self.user = user
                    print(user)
                case .failure(let error):
                    print("upload image failure")
                    print(error)
                }
                self.isLoading = false
                completion(self.user)
            }
        }
    }
    
    func characterRename(cid: String, characterName: String, isDefault: Bool = false, completion: @escaping () -> Void) {
        characterAPI.putCharacterRename(cid: cid, name: characterName, isDefault: isDefault) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    print("rename success")
                    print(user)
                    completion()
                case .failure(let error):
                    print("rename failure")
                    print(error)
                }
            }
        }
    }
}
