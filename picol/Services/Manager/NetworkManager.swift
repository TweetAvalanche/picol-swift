//
//  NetworkManager.swift
//  picol
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    // 基本的なGETリクエストメソッド
    func get<T: Decodable>(url: URL,
                           headers: [String: String]? = nil,
                           completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let headers = headers {
            for (field, value) in headers {
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    // 基本的なPOSTリクエストメソッド
    func post<T: Decodable, U: Encodable>(url: URL,
                                          headers: [String: String]? = nil,
                                          body: U,
                                          completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let headers = headers {
            for (field, value) in headers {
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let requestData = try JSONEncoder().encode(body)
            request.httpBody = requestData
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    func postWithoutBody<T: Decodable>(url: URL,
                                       headers: [String: String]? = nil,
                                       completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let headers = headers {
            for (field, value) in headers {
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        
        // ボディは付与しない
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    // 基本的なPUTリクエストメソッド
    func put<T: Decodable, U: Encodable>(url: URL,
                                         headers: [String: String]? = nil,
                                         body: U,
                                         completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        if let headers = headers {
            for (field, value) in headers {
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let requestData = try JSONEncoder().encode(body)
            request.httpBody = requestData
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    // マルチパートで画像をアップロードする処理（実際のリクエスト送信部分のみ）
    func uploadImage(url: URL,
                     image: UIImage,
                     headers: [String: String]? = nil,
                     completion: @escaping (Result<String, Error>) -> Void) {
        // ここではMultipartRequestBuilderに任せてRequestを作成
        guard let request = MultipartRequestBuilder.makeMultipartRequest(url: url, image: image, headers: headers) else {
            completion(.failure(NSError(domain: "RequestCreationError", code: -1, userInfo: nil)))
            return
        }
        
        // あとはリクエストを飛ばしてレスポンスをハンドリングする
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)))
                return
            }
            
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                return
            }
            
            completion(.success(responseString))
        }.resume()
    }
    
    // レスポンス共通処理
    private func handleResponse<T: Decodable>(data: Data?,
                                              response: URLResponse?,
                                              error: Error?,
                                              completion: @escaping (Result<T, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
            return
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            // ステータスコードによるエラーハンドリング
            completion(.failure(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)))
            return
        }
        
        guard let data = data else {
            completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
        } catch {
            completion(.failure(error))
        }
    }
}
