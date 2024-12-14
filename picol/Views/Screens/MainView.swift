//
//  MainView.swift
//  picol
//

import SwiftUI

struct MainView: View {
    var type: String = "Fire"
    var mode: String = "Flash"
    
    var body: some View {
        VStack {
            PicolImage(type: type, mode: mode)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("Picol\(type)\(mode) tapped")
                }
        }
        .backgroundImage("MainBackground")
    }
}

#Preview {
    MainView()
}
