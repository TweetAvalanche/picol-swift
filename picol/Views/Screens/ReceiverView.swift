//
//  ReceiverView.swift
//  picol
//

import SwiftUI

struct ReceiverView: View {
    @StateObject var flashReceiver = FlashReceiver()
    @StateObject private var viewModel = PicolImageViewModel()
    
    @AppStorage("defaultCharacter") var defaultCharacter = "2ffffff"

    var body: some View {
        ZStack{
            VStack {
                
                VStack{
                    Text("メッセージを受信")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding(.top, 40.0)
                    Text("\(flashReceiver.statusText)")
                        .font(.system(size: 20))
                        .foregroundColor(Color.white)
                }
                Spacer()
                Image("Picol\(viewModel.type)Back1")
                    .resizable()
                //                .padding(.bottom, 100.0)
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                Spacer()
                Spacer()
            }
            .backgroundImage("MultiBackground")
            
            if flashReceiver.isFlash {
                VStack{
                    Spacer()
                    Image("MultiStar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100.0, height: 100.0)
                        .padding(.leading, 280.0)
                    Spacer()
                    Spacer()
                }
            }
                
        }
        .onAppear {
            flashReceiver.startSession()
            viewModel.getTypeFromParam(param: defaultCharacter)
        }
        .onDisappear {
            flashReceiver.stopSession()
        }
        .sheet(isPresented: $flashReceiver.isFinish) {
            if let receivedUser = flashReceiver.receivedUserData {
                ReceiverModalView(receivedUser: receivedUser)
            }
        }
    }
}

#Preview {
    ReceiverView()
}
