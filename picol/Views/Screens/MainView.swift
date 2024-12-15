//
//  MainView.swift
//  picol
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = PicolImageViewModel()
    @State private var position: CGPoint = CGPoint(x: 0.5, y: 0.5)
    @State private var mode: String = "wait"
    @AppStorage("defaultCharacter") var defaultCharacter = "2ffffff"
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
            GeometryReader { geometry in
                ZStack {
                    PicolImage()
                        .frame(width: 300, height: 300)
                        .position(x: geometry.size.width * position.x, y: geometry.size.height * position.y) // X:[ 0.2-0.8 ] Y:[ 0.4-0.75 ]
                        .onTapGesture {
                            mode = "walk"
                        }
                        .environmentObject(viewModel) // Pass viewModel as EnvironmentObject
                        .onChange(of: mode) { oldMode, newMode in
                            if newMode == "walk" {
                                let newX = CGFloat.random(in: 0.2...0.8)
                                let newY = CGFloat.random(in: 0.4...0.75)
                                let distance = sqrt(pow(newX - position.x, 2) + pow(newY - position.y, 2))
                                let duration = Double(distance) * 15.0 // 距離に応じて duration を設定
                                withAnimation(.linear(duration: duration)) {
                                    position = CGPoint(x: newX, y: newY)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                    mode = "wait"
                                }
                            }
                        }
                        .onAppear {
                            viewModel.getTypeFromParam(param: defaultCharacter)
                            Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
                                viewModel.face = viewModel.faces.randomElement() ?? ""
                            }
                            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                                if Int.random(in: 1...4) == 1 {
                                    mode = "walk"
                                }
                            }
                        }
                }
            }
        }.backgroundImage("MainBackground")
    }
}

#Preview {
    MainView()
}
