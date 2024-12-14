//
//  MainView.swift
//  picol
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            PicolImage()
                .frame(width: 300, height: 300)
                .onTapGesture {
                    if viewModel.face == "Sad" {
                        viewModel.face = "Flash"
                        return
                    }
                    viewModel.face = "Sad" // Change mode state
                }
                .environmentObject(viewModel) // Pass viewModel as EnvironmentObject
        }
        .backgroundImage("MainBackground")
    }
}

#Preview {
    MainView()
}
