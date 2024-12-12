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
                ContentView()
            } else {
                TitleView(onStart: {
                    showMainView = true
                })
            }
        }
    }
}
