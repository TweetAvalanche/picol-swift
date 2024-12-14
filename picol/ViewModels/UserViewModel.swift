//
//  UserViewModel.swift
//  picol
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoading = true
    
    private let userAPI = UserAPI()
    private let keychain = KeychainManager.shared
    
    func createUser() {
        print("createUser")
        isLoading = true
        
        userAPI.createUser { [weak self] result in
            DispatchQueue.main.async {
                print("createUser result")
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let user):
                    print("user: \(user)")
                    self.currentUser = user
                    let isSet = self.keychain.save(key: "uid", value: String(user.uid))
                    if !isSet {
                        self.errorMessage = "Failed to save uid"
                    }
                case .failure(let error):
                    print("error: \(error)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func loadUser(completion: @escaping () -> Void) {
        print("loadUser")
        guard let uid = keychain.load(key: "uid") else {
            print("uid not found")
            completion()
            return
        }
        
        print("uid: \(uid)")
        
        isLoading = true
        errorMessage = nil
        
        userAPI.fetchUser(uid: uid) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let user):
                    print("user: \(user)")
                    self.currentUser = user
                case .failure(let error):
                    print("error: User not found")
                    self.keychain.delete(key: "uid")
                    self.errorMessage = error.localizedDescription
                    completion()
                }
            }
        }
    }
}
