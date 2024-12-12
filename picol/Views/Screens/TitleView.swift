//
//  TitleView.swift
//  picol
//

import SwiftUI

struct TitleView: View {
    let onStart: () -> Void

    @State private var showOverlay = false
    @State private var isOn = true

    var body: some View {
        ZStack {
            VStack {
                Image(isOn ? "logoOn" : "logoOff")
                    .resizable()
                    .padding([.leading, .trailing], 20.0)
                    .padding(.top, 120.0)
                    .scaledToFit()

                Spacer()
                if isOn {
                    Image("titleChar")
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, 100.0)
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
