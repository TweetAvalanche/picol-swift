//
//  ImageAPI.swift
//  picol
//

import Foundation
import UIKit

class CharacterAPI {
    func postCharacter(uid: String, fileURL: URL, completion: @escaping (Result<User, Error>) -> Void) {
        var components = URLComponents(string: "https://p2flash.fynsv.net/character")!
        components.queryItems = [URLQueryItem(name: "uid", value: uid)]

        guard let url = components.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        print("postCharacter: \(url)")
        
        NetworkManager.shared.postFile(url: url, fileURL: fileURL, fieldName: "image") { result in
            completion(result)
        }
    }
}
