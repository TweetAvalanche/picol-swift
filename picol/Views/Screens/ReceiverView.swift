//
//  ReceiverView.swift
//  picol
//

import SwiftUI

struct ReceiverView: View {
    @ObservedObject var flashReceiver = FlashReceiver()

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
            Spacer()
        }.backgroundImage("MainBackground")
    }
}

#Preview {
    ReceiverView()
}
