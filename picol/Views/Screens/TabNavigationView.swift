//
//  TabNavigationView.swift
//  picol
//

import SwiftUI

struct TabNavigationView: View {
    @StateObject var userViewModel = UserViewModel()
    @State private var selectedTab: Int = 0
    @State private var isTabLocked: Bool = false

    var body: some View {
        ZStack {
            if userViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .backgroundColor("bgTitleColorOff")
            } else {
                TabView(selection: $selectedTab) {
                    MainView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                        .tag(0)
                        .onAppear {
                            SoundManager.shared.playBGM(named: "home_bgm")
                        }
                    CameraView()
                        .tabItem {
                            Image(systemName: "camera")
                            Text("Camera")
                        }
                        .tag(1)
                        .onAppear {
                            SoundManager.shared.playBGM(named: "trans_bgm")
                        }
                    ReceiverView()
                        .tabItem {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                            Text("Receive")
                        }
                        .tag(2)
                        .onAppear {
                            SoundManager.shared.playBGM(named: "trans_bgm")
                        }
                    TransmitterView()
                        .tabItem {
                            Image(systemName: "paperplane")
                            Text("Send")
                        }
                        .tag(3)
                        .onAppear {
                            SoundManager.shared.playBGM(named: "trans_bgm")
                        }
                }
                .disabled(isTabLocked)
                .onChange(of: selectedTab) { _ in
                    isTabLocked = true
                    print("Tab locked")
                    // 5秒後にアンロック
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        print("Tab unlocked")
                        isTabLocked = false
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
