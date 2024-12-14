//
//  APIResponseModels.swift
//  picol
//

import Foundation

struct User: Codable {
    let uid: Int
    let user_message: String
    let cid: Int
    let character_name: String
    let character_param: String
    let character_aura_image: String
}

struct Token: Codable {
    let token: String
}

struct Count: Codable {
    let character_count: Int
}
