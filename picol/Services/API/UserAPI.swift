//
//  UserAPI.swift
//  picol
//

import Foundation

class UserAPI {
    func createUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "https://p2flash.fynsv.net/user") else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }

        NetworkManager.shared.post(url: url) { result in
            completion(result)
        }
    }

    func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        var components = URLComponents(string: "https://p2flash.fynsv.net/user")!
        components.queryItems = [URLQueryItem(name: "uid", value: uid)]

        guard let url = components.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }

        NetworkManager.shared.get(url: url) { result in
            completion(result)
        }
    }
}
