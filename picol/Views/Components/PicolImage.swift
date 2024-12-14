//
//  PicolImage.swift
//  picol
//

import SwiftUI

struct PicolImage: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isSceneOne = true
    
    var body: some View {
        Image("Picol\(viewModel.type)\(viewModel.face)\(isSceneOne ? "1" : "2")")
            .resizable()
            .scaledToFit()
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    let currentSecond = Calendar.current.component(.second, from: Date())
                    isSceneOne = currentSecond % 2 == 0
                }
            }
    }
}
