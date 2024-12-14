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
    
    func putCharacterRename(cid: String, name: String, isDefault: Bool, completion: @escaping (Result<User, Error>) -> Void) {
        var components = URLComponents(string: "https://p2flash.fynsv.net/character/rename")!
        components.queryItems = [URLQueryItem(name: "cid", value: cid), URLQueryItem(name: "character_name", value: name), URLQueryItem(name: "make_default=1", value: isDefault ? "1" : "0")]

        guard let url = components.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        print("putCharacterRename: \(url)")
        
        NetworkManager.shared.put(url: url) { result in
            completion(result)
        }
    }

    struct CharacterCountResponse: Decodable {
        let character_count: String
    }

    func countCharacters(uid: String, completion: @escaping (Result<Count, Error>) -> Void) {
        var components = URLComponents(string: "https://p2flash.fynsv.net/character/count")!
        components.queryItems = [URLQueryItem(name: "uid", value: uid)]

        guard let url = components.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }

        print("countCharacters: \(url)")

        NetworkManager.shared.get(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(CharacterCountResponse.self, from: data)
                    completion(.success(Count(character_count: response.character_count)))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
