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
    
    // post
    func post<T: Decodable>(url: URL,
                            headers: [String: String]? = nil,
                            completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 共通ヘッダー設定
        if let headers = headers {
            for (field, value) in headers {
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    // 基本的なPUTリクエストメソッド
    func put<T: Decodable>(url: URL,
                           headers: [String: String]? = nil,
                           completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        if let headers = headers {
            for (field, value) in headers {
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

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
    
    func postFile<T: Decodable>(url: URL,
                                headers: [String: String]? = nil,
                                fileURL: URL,
                                fieldName: String = "file",
                                completion: @escaping (Result<T, Error>) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // boundary の生成
        let boundary = "Boundary-\(UUID().uuidString)"
        
        // ヘッダー設定
        if let headers = headers {
            for (field, value) in headers {
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // マルチパートボディの生成
        let httpBody = createMultipartBody(fileURL: fileURL, fieldName: fieldName, boundary: boundary)
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("リクエスト送信")
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }

    private func createMultipartBody(fileURL: URL, fieldName: String, boundary: String) -> Data {
        var body = Data()
        
        // ファイルデータの読み込み
        guard let fileData = try? Data(contentsOf: fileURL) else {
            return body
        }
        
        // ファイルのファイル名（最後のパスコンポーネントを利用）
        let filename = fileURL.lastPathComponent
        let mimeType = mimeTypeForPathExtension(fileURL.pathExtension)
        
        // データの組み立て
        // フォームデータ開始
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        
        // Content-Disposition ヘッダ(ここでファイル名・field名を指定)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        // Content-Type ヘッダ(MIMEタイプを設定)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        
        // ファイルデータ本体
        body.append(fileData)
        body.append("\r\n".data(using: .utf8)!)
        
        // フォームデータ終了
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }

    private func mimeTypeForPathExtension(_ ext: String) -> String {
        // 簡易的なMIMEタイプ判定
        switch ext.lowercased() {
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "gif":
            return "image/gif"
        default:
            return "application/octet-stream"
        }
    }
    
    // レスポンス共通処理
    private func handleResponse<T: Decodable>(data: Data?,
                                              response: URLResponse?,
                                              error: Error?,
                                              completion: @escaping (Result<T, Error>) -> Void) {
        if let error = error {
            print("Error: \(error)")
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
            return
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            // ステータスコードによるエラーハンドリング
            if let data = data { print("data:\(data)") }
            if let response = response { print("response:\(response)") }
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
