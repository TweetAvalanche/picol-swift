//
//  MainView.swift
//  picol
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Image("PicolFire")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .onTapGesture {
                    print("PicolFire tapped")
                }
                
        }
        .backgroundImage("MainBackground")
    }
}

#Preview {
    MainView()
}
