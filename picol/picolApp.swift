//
//  picolApp.swift
//  picol
//

import SwiftUI

@main
struct picolApp: App {
    @State private var showMainView = false

    var body: some Scene {
        WindowGroup {
            if showMainView {
                TabNavigationView()
            } else {
                TitleView(onStart: {
                    showMainView = true
                })
                .onAppear {
                    SoundManager.shared.playBGM(named: "title_bgm")
                }
            }
        }
    }
}
