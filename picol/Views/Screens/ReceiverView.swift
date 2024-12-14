//
//  ReceiverView.swift
//  picol
//

import SwiftUI

struct ReceiverView: View {
    @StateObject var flashReceiver = FlashReceiver()

    var body: some View {
        ZStack{
            VStack {
                //デバック用
                //            GeometryReader { geometry in
                //                CameraPreview(session: flashReceiver.getSession())
                //                    .overlay(
                //                        VStack {
                //                            Spacer()
                //                            HStack {
                //                                Text(String(format: "FPS: %.2f", flashReceiver.fps))
                //                                    .padding(5)
                //                                    .background(Color.black.opacity(0.5))
                //                                    .foregroundColor(.white)
                //                                    .cornerRadius(8)
                //                                Spacer()
                //                                Text(String(format: "Processing: %.3f s", flashReceiver.processingTime))
                //                                    .padding(5)
                //                                    .background(Color.black.opacity(0.5))
                //                                    .foregroundColor(.white)
                //                                    .cornerRadius(8)
                //                            }
                //                            .padding()
                //                        }
                //                    )
                //            }
                //            .padding(10)
                //            .aspectRatio(1, contentMode: .fit)
                //            Text("状態: \(flashReceiver.statusText)")
                //            ProgressView(value: flashReceiver.progress, total: 1.0)
                //                .padding()
                //            Text("最後の受信データ: \(flashReceiver.lastReceivedData)")
                //            Text("最大輝度: \(flashReceiver.getLuminance())")
                //                .monospaced()
                //            Spacer()
                
//                Text(flashReceiver.isFlash ? "光" : "無")
//                    .foregroundColor(.white)
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
            .onAppear {
                flashReceiver.startSession()
            }
            .onDisappear {
                flashReceiver.stopSession()
            }
            
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
    }
}

#Preview {
    ReceiverView()
}
