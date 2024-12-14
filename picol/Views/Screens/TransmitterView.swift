//
//  TransmitterView.swift
//  picol
//

import SwiftUI

struct TransmitterView: View {
    @ObservedObject var flashTransmitter = FlashTransmitter()
    @StateObject var tokenViewModel = TokenViewModel()
    @StateObject private var viewModel = PicolImageViewModel()
    @StateObject var userViewModel = UserViewModel()
    
    //ユーザー設定メッセージ
    @State private var inputMessage = ""
    @FocusState var isFocused: Bool
    
    @AppStorage("defaultCharacter") var defaultCharacter = "2ffffff"
    @AppStorage("userMessage") var userMessage = "こんにちは"
    
    var body: some View {
        VStack {
            Text("メッセージを送信")
                .font(.title)
                .foregroundColor(Color.white)
                .padding(.top, 40.0)
            HStack{
                Button(action: {
                    inputMessage = ""
                }, label: {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 24))
//                        .padding()
//                        .backgroundColor("bgButton")
                        .foregroundColor(.white)
                        .frame(width: 30.0, height: 30.0)
                        .cornerRadius(10)
                        .padding(.leading, 25.0)
                })
                TextField("ユーザー設定メッセージ", text: $userMessage)
                    .padding()
                    .background(.white)
                    .frame(width: 250.0, height: 60.0)
                    .font(.system(size: 25))
                    .cornerRadius(10)
                    
                    .focused($isFocused)
                Button(action: {
                    isFocused = false
                    userViewModel.updateUserMessage(message: userMessage) {
                        let encodedData = flashTransmitter.makeHexSendData(hex: tokenViewModel.transmitterToken!)
                        flashTransmitter.send(data: encodedData)
                    }
                }, label: {
                    if tokenViewModel.isTransmitterToken{
                        //送信
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 24))
                            .padding()
                            .backgroundColor("bgButton")
                            .foregroundColor(.white)
                            .frame(width: 60.0, height: 60.0)
                            .cornerRadius(10)
                            .padding(.trailing, 25.0)
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .foregroundColor(.white)
                    }
                }).disabled(!tokenViewModel.isTransmitterToken)
            }
//            .padding(.top, 10.0)
            Spacer()
            Image("Picol\(viewModel.type)Back1")
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
            viewModel.getTypeFromParam(param: defaultCharacter)
        }
    }
}

#Preview {
    TransmitterView(flashTransmitter: FlashTransmitter(), tokenViewModel: TokenViewModel())
}
