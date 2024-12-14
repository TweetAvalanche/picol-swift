//
//  TransmitterView.swift
//  picol
//

import SwiftUI

struct TransmitterView: View {
    @ObservedObject var flashTransmitter = FlashTransmitter()
    @StateObject var tokenViewModel = TokenViewModel()
    
    @State private var inputName = ""
    
    var body: some View {
        VStack {
//            Text("送信画面")
//                .font(.title)
//                .padding()
            HStack{
                TextField("ユーザー設定メッセージ", text: $inputName)
                    .background(.white)
                    .font(.system(size: 30))
                    .cornerRadius(10)
                    .padding(.top, 40.0)
                    .padding(.leading, 25.0)
                Button(action: {
                    let encodedData = flashTransmitter.makeHexSendData(hex: tokenViewModel.transmitterToken!)
                    flashTransmitter.send(data: encodedData)
                }, label: {
                    if tokenViewModel.isTransmitterToken == false {
                        Text("送信")
                            .font(.title)
                            .padding()
                            .backgroundColor("bgButton")
                            .foregroundColor(.white)
                            .frame(width: 100.0, height: 60.0)
                            .cornerRadius(10)
                            .padding(.trailing, 25.0)
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .foregroundColor(.white)
                    }
                }).disabled(tokenViewModel.isTransmitterToken)
                    .padding(.top, 40.0)
            }
            Spacer()
            Image("PicolFire1")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .onTapGesture {
                    print("PicolFire tapped")
                }
            Spacer()
            Spacer()
        }
        .backgroundImage("MultiBackground")
        .onAppear {
            tokenViewModel.createToken()
        }
    }
}

#Preview {
    TransmitterView(flashTransmitter: FlashTransmitter(), tokenViewModel: TokenViewModel())
}
