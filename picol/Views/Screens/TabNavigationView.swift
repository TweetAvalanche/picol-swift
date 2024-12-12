//
//  TabNavigationView.swift
//  picol
//

import SwiftUI

struct TabNavigationView: View {
    @StateObject var userViewModel = UserViewModel()

    var body: some View {
        ZStack {
            if userViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .backgroundColor("bgTitleColorOff")
            } else {
                TabView {
                    MainView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                }
            }
        }
        .onAppear {
            userViewModel.loadUser() {
                print("User loaded")
                if userViewModel.currentUser == nil {
                    print("User not found")
                    userViewModel.createUser()
                }
            }
        }
    }
}

#Preview {
    TabNavigationView()
}
