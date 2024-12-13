//
//  TransmitterView.swift
//  picol
//

import SwiftUI

struct TransmitterView: View {
    @ObservedObject var flashTransmitter = FlashTransmitter()
    @StateObject var tokenViewModel = TokenViewModel()
    
    var body: some View {
        VStack {
            Text("送信画面")
                .font(.title)
                .padding()
            Button(action: {
                let encodedData = flashTransmitter.makeHexSendData(hex: tokenViewModel.transmitterToken!)
                flashTransmitter.send(data: encodedData)
            }, label: {
                if tokenViewModel.isTransmitterToken {
                    Text("送信")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                }
            }).disabled(tokenViewModel.isTransmitterToken)
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
