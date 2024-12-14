//
//  ReceiverModalView.swift
//  picol
//
//  Created by 遠藤七佳 on 2024/12/14.
//

import SwiftUI

struct ReceiverModalView: View {
    var body: some View {
        ZStack{
            ZStack{
                Image("MultiResultBubble")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280, height: 280)
                    .padding(.bottom, 300.0)
                VStack{
                    Spacer()
                    Text("Helloooooooo\nHello!\nHello!\nHello!")
                        .font(.system(size: 35))
                        .foregroundColor(.black)
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                        .frame(width: 220.0, height: 180)
                        .padding(.bottom, 60.0)
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
            Image("MultiResultGround")
                .resizable()
                .padding()
                .scaledToFit()
//                .frame(width: 250, height: 250)
            ZStack{
                //キャラクター表示
                VStack{
                    Spacer()
                    Spacer()
                    ZStack{
                        Image("PicolFire1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding(.trailing, 150.0)
                            .padding(.top, 30.0)
                        Text("ファイアー1")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding(.all, 3.0)
                            .background(.bgButton)
                            .cornerRadius(10)
                            .padding(.trailing, 150.0)
                            .padding(.top, 270.0)
                    }
                    Spacer()
                }
                Spacer()
                VStack{
                    Spacer()
                    Spacer()
                    ZStack{
                        Image("PicolFire1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding(.leading, 150.0)
                            .padding(.top, 30.0)
                        Text("ファイヤー2")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding(.all, 3.0)
                            .background(.bgButton)
                            .cornerRadius(10)
                            .padding(.leading, 150.0)
                            .padding(.top, 270.0)
                    }
                    Spacer()
                }
            }
            VStack{
                Spacer()
                Button(action: {
                    //go main??
                }, label:{
                    Image(systemName: "arrowshape.turn.up.backward.circle")
                        .foregroundColor(.white)
                        .font(.system(size: 50))
                })
            }
        }
        .backgroundImage("MultiResultBackground")
    }
}

#Preview {
    ReceiverModalView()
}
