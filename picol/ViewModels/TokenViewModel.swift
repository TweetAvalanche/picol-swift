//
//  TokenViewModel.swift
//  picol
//

import Foundation

class TokenViewModel: ObservableObject {
    @Published var transmitterToken: String?
    @Published var receivedUser: User?
    private let tokenAPI = TokenAPI()
    private let keychain = KeychainManager.shared

    func createToken() {
        let uid = getUid()
        
        tokenAPI.createToken(uid: uid) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.transmitterToken = data.token
                    print("data: \(data)")
                case .failure(let error):
                    print("error: \(error)")
                }
            }
        }
    }
    
    func loadToken(token: String, completion: @escaping () -> Void) {
        tokenAPI.fetchToken(token: token) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.receivedUser = data
                    print("data: \(data)")
                case .failure(let error):
                    print("error: \(error)")
                }
                completion()
            }
        }
    }
    
    private func getUid() -> String {
        guard let uid = keychain.load(key: "uid") else {
            print("uid not found")
            return ""
        }
        
        return uid
    }
}
