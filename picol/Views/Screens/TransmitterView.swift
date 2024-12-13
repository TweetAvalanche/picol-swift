//
//  TransmitterView.swift
//  picol
//

import SwiftUI

struct TransmitterView: View {
    @ObservedObject var flashTransmitter = FlashTransmitter()
    
    var body: some View {
        VStack {
            Text("送信画面")
                .font(.title)
                .padding()
            Button(action: {
                let encodedData = flashTransmitter.makeHexSendData(hex: "123abc")
                flashTransmitter.send(data: encodedData)
            }, label: {
                Text("送信")
            })
        }.backgroundImage("MultiBackground")
    }
}
