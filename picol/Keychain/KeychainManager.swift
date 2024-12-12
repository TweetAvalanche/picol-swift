//
//  KeychainManager.swift
//  picol
//

import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    
    func save(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }

        // 既存値削除
        let queryDelete: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key as CFString
        ]
        SecItemDelete(queryDelete as CFDictionary)

        // 新規登録
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key as CFString,
            kSecValueData: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func load(key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key as CFString,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return string
    }
    
    func delete(key: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key as CFString
        ]
        SecItemDelete(query as CFDictionary)
    }
}
