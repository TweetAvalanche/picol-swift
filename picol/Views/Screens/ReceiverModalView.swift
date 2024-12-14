//
//  ReceiverModalView.swift
//  picol
//
//  Created by 遠藤七佳 on 2024/12/14.
//

import SwiftUI

struct ReceiverModalView: View {
    var body: some View {
        VStack{
//            VStack{
            Rectangle()
                .stroke(lineWidth: 3)
                .frame(width: 300, height: 8)
                .cornerRadius(10)
                .foregroundStyle(.white)
                .scaledToFit()
//                    .padding(.top, 0.0)
//            }
            Spacer()
            
            VStack{
                ZStack{
                    
                    Image("MultiResultBubble")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 280)
                    Text("Helloooooooo\nHello!\nHello!\nHello!")
                        .font(.system(size: 35))
                        .foregroundColor(.black)
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                        .frame(width: 220.0, height: 180)
                        .padding(.bottom, 30.0)
                    
                }
                .padding(.top, 10.0)
                ZStack{
                    Image("MultiResultGround")
                        .resizable()
                        .frame(width: 300, height: 90)
                        .scaledToFit()
                        .padding(.top, 200.0)
                    //キャラクター表示
                    VStack{
                        Image("PicolFire1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        Text("ファイアー1")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding(.all, 3.0)
                            .background(.bgButton)
                            .cornerRadius(10)
                    }.padding(.trailing, 150.0)
                    VStack{
                        Image("PicolFire1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        Text("ファイヤー2")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding(.all, 3.0)
                            .background(.bgButton)
                            .cornerRadius(10)
                    }.padding(.leading, 150.0)
                }
            }
            Spacer()
        }
//            .scaledToFit()
            .backgroundImage("MultiResultBackground")
    }
}

#Preview {
    ReceiverModalView()
}
