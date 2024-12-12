//
//  TabNavigationView.swift
//  picol
//

import SwiftUI

struct TabNavigationView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
        }
    }
}

#Preview {
    TabNavigationView()
}
