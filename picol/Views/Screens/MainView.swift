//
//  MainView.swift
//  picol
//

import SwiftUI

struct MainView: View {
    @State private var isPicolFire1 = true
    var type: String = "Picol"
    var mode: String = "Fire"
    
    var body: some View {
        VStack {
            Image("\(type)\(mode)\(isPicolFire1 ? "1" : "2")")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("\(type)\(mode) tapped")
                }
        }
        .backgroundImage("MainBackground")
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                isPicolFire1.toggle()
            }
        }
    }
}

#Preview {
    MainView()
}
