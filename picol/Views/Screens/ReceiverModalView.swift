//
//  ReceiverModalView.swift
//  picol
//
//  Created by 遠藤七佳 on 2024/12/14.
//

import SwiftUI

struct ReceiverModalView: View {
    @StateObject private var viewModel1 = PicolImageViewModel()
    @StateObject private var viewModel2 = PicolImageViewModel()

    let receivedUser: User

    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .stroke(lineWidth: 3)
                    .frame(width: 300, height: 8)
                    .cornerRadius(10)
                    .foregroundStyle(.white)
                    .scaledToFit()
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
                            PicolImage()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .environmentObject(viewModel1)
                                .onTapGesture {
                                    viewModel1.getTypeFromParam(param: "2ffffff")
                                }
                            Text("ファイアー1")
                                .foregroundColor(.white)
                                .font(.title2)
                                .padding(.all, 3.0)
                                .background(.bgButton)
                                .cornerRadius(10)
                        }.padding(.trailing, 150.0)
                        VStack{
                            PicolImage()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .environmentObject(viewModel2)
                                .onTapGesture {
                                    viewModel2.getTypeFromParam(param: "2ffffff")
                                }
                            Text(receivedUser.character_name)
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

        }
        .backgroundImage("MultiResultBackground")

    }
}

#Preview {
    ReceiverModalView(receivedUser: User(
        uid: 2,
        user_message: "ファイアー2",
        cid: 2,
        character_name: "hoge",
        character_param: "hogehoge",
        character_aura_image: "2"
    ))
}
