//
//  PicolImage.swift
//  picol
//

import SwiftUI

struct PicolImage: View {
    var type: String
    var mode: String
    @State private var isPicolFire1 = true
    
    var body: some View {
        Image("Picol\(type)\(mode)\(isPicolFire1 ? "1" : "2")")
            .resizable()
            .scaledToFit()
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    isPicolFire1.toggle()
                }
            }
    }
}
