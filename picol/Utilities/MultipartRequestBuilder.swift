//
//  MultipartRequestBuilder.swift
//  picol
//

import Foundation
import UIKit

struct MultipartRequestBuilder {
    static func makeMultipartRequest(url: URL,
                                     image: UIImage,
                                     headers: [String: String]? = nil,
                                     fieldName: String = "image",
                                     fileName: String = "image.jpg") -> URLRequest? {
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // ヘッダーの設定
        if let headers = headers {
            for (field, value) in headers {
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // マルチパートボディの生成
        let httpBody = createMultipartBody(imageData: imageData, boundary: boundary, fileName: fileName, fieldName: fieldName)
        request.httpBody = httpBody
        
        return request
    }
    
    private static func createMultipartBody(imageData: Data,
                                            boundary: String,
                                            fileName: String,
                                            fieldName: String) -> Data {
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
}
