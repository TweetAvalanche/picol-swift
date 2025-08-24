//
//  TokenAPI.swift
//  picol
//

import Foundation

class TokenAPI {
    func createToken(uid: String, completeion: @escaping (Result<Token, Error>) -> Void) {
        var components = URLComponents(string: "https://p2flash.uiro.net/token")!
        components.queryItems = [URLQueryItem(name: "uid", value: uid)]
        
        guard let url = components.url else {
            completeion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        NetworkManager.shared.post(url: url) { result in
            completeion(result)
        }
    }
    
    func fetchToken(token: String, completion: @escaping (Result<User, Error>) -> Void) {
        var components = URLComponents(string: "https://p2flash.uiro.net/token")!
        components.queryItems = [URLQueryItem(name: "token", value: token)]
        
        guard let url = components.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        print("tokenurl: \(url)")
        
        NetworkManager.shared.get(url: url) { result in
            completion(result)
        }
    }
}
