//
//  TitleView.swift
//  picol
//

import SwiftUI

struct TitleView: View {
    @StateObject private var permissionsManager = PermissionsManager()

    let onStart: () -> Void

    @State private var showOverlay = false
    @State private var isOn = true

    var body: some View {
        ZStack {
            
                Image(isOn ? "logoOn" : "logoOff")
                    .resizable()
                    .scaledToFit()
//                    .padding([.leading, .trailing], 20.0)
                    .padding(.bottom, 230.0)
                    
            VStack {
                Spacer()
                Spacer()
                if isOn {
                    ZStack{
                        Image("titleChar")
                            .resizable()
                            .scaledToFit()
                            .padding(.top, 350.0)
                        Image("StartArrow")
                            .resizable()
                            .scaledToFit()
                    }
                }
                
                
            }.animation(.easeInOut(duration: 0.5), value: isOn)

            if showOverlay {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
            }
        }.animation(.easeOut(duration: 1.5), value: showOverlay)
        .backgroundColor(isOn ? "bgTitleColorOn" : "bgTitleColorOff")
        .gesture(
            DragGesture()
                // 下方向に100px以上ドラッグしたらトリガー
                .onEnded { value in
                    if value.translation.height > 100 && isOn {
                        isOn = false
                        SoundManager.shared.playSE(named: "main_view_se")
                        delay(0.5) {
                            showOverlay = true
                            delay(2) {
                                onStart()
                            }
                        }
                    }
                }
        )
    }
}

#Preview {
    TitleView(onStart: {})
}
