//
//  PicolImage.swift
//  picol
//

import SwiftUI

struct PicolImage: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State private var isSceneOne = true
    
    var viewface: String {
        viewModel.face == "Heart" ? "Fine" : viewModel.face == "Angry" ? "Sad" : viewModel.face
    }
    
    var isHeart: Bool {
        viewModel.face == "Heart"
    }

    var isAngry: Bool {
        viewModel.face == "Angry"
    }
    
    var body: some View {
        ZStack {
            Image("Picol\(viewModel.type)\(viewface)\(isSceneOne ? "1" : "2")")
                .resizable()
                .scaledToFit()
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) {
                        _ in
                        isSceneOne.toggle()
                    }
                }
            if isHeart {
                Image("PicolEffectHeart\(isSceneOne ? "1" : "2")")
                    .resizable()
                    .scaledToFit()
            }
            if isAngry {
                Image("PicolEffectAngry")
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

struct PicolImage_Previews: PreviewProvider {
    static var previews: some View {
        PicolImage().environmentObject(MainViewModel())
    }
}
