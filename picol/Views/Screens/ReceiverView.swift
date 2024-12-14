//
//  ReceiverView.swift
//  picol
//

import SwiftUI

struct ReceiverView: View {
    @StateObject var flashReceiver = FlashReceiver()

    var body: some View {
        VStack {
            Text("受信画面")
            GeometryReader { geometry in
                CameraPreview(session: flashReceiver.getSession())
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Text(String(format: "FPS: %.2f", flashReceiver.fps))
                                    .padding(5)
                                    .background(Color.black.opacity(0.5))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                Spacer()
                                Text(String(format: "Processing: %.3f s", flashReceiver.processingTime))
                                    .padding(5)
                                    .background(Color.black.opacity(0.5))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding()
                        }
                    )
            }
            .padding(10)
            .aspectRatio(1, contentMode: .fit)
            Text("状態: \(flashReceiver.statusText)")
            ProgressView(value: flashReceiver.progress, total: 1.0)
                .padding()
            Text("最後の受信データ: \(flashReceiver.lastReceivedData)")
            Text("最大輝度: \(flashReceiver.getLuminance())")
                .monospaced()
            Spacer()
        }
        .backgroundImage("MultiBackground")
        .onAppear {
            flashReceiver.startSession()
        }
        .onDisappear {
            flashReceiver.stopSession()
        }
    }
}

#Preview {
    ReceiverView()
}
