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
    
    func putCharacterRename(cid: String, name: String, completion: @escaping (Result<User, Error>) -> Void) {
        var components = URLComponents(string: "https://p2flash.fynsv.net/character/rename")!
        components.queryItems = [URLQueryItem(name: "cid", value: cid), URLQueryItem(name: "character_name", value: name)]

        guard let url = components.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        print("putCharacterRename: \(url)")
        
        NetworkManager.shared.put(url: url) { result in
            completion(result)
        }
    }
    
    func getAllCharacter(uid: String, completion: @escaping (Result<[User], Error>) -> Void) {
        var components = URLComponents(string: "https://p2flash.fynsv.net/character/all")!
        components.queryItems = [URLQueryItem(name: "uid", value: uid)]

        guard let url = components.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        print("getAllCharacter: \(url)")
        
        NetworkManager.shared.get(url: url) { result in
            completion(result)
        }
    }
    
    func putDefaultCharacter(cid: String, completion: @escaping (Result<User, Error>) -> Void) {
        var components = URLComponents(string: "https://p2flash.fynsv.net/character/default")!
        components.queryItems = [URLQueryItem(name: "cid", value: cid)]
        
        guard let url = components.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        print("putDefaultCharacter: \(url)")
        
        NetworkManager.shared.put(url: url) { result in
            completion(result)
        }
    }
}
