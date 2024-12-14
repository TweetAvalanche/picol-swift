//
//  ReceiverView.swift
//  picol
//

import SwiftUI

struct ReceiverView: View {
    @ObservedObject var flashReceiver = FlashReceiver()
    @State private var CameraMessage = ""
    
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
                Image("PicolFireBack1")
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
