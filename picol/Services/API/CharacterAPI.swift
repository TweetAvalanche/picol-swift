//
//  ImageAPI.swift
//  picol
//

import Foundation
import UIKit

class CharacterAPI {
    func postCharacter(uid: String, image: UIImage, completion: @escaping (Result<User, Error>) -> Void) {
        var components = URLComponents(string: "https://p2flash.fynsv.net/character")!
        components.queryItems = [URLQueryItem(name: "uid", value: uid)]

        guard let url = components.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        NetworkManager.shared.uploadImage(url: url, image: image, headers: ["Authorization": "Bearer xxx"]) { result in
            completion(result)
        }
    }
}
