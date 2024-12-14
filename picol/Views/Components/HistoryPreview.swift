//
//  HistoryPreview.swift
//  picol
//

import SwiftUI

struct HistoryPreview: View {
    let user: User
    @State private var c_type = ""
    @State private var c_color = ""
    let typeCodeToTypeDic = ["1": "Fire", "2": "Star", "3": "Moon", "4": "Light", "5": "Bulb", "6": "Sun"]
    
    @AppStorage("defaultCharacter") var defaultCharacter = "2ffffff"
    
    @StateObject var characterViewModel = CharacterViewModel()

    var body: some View {
        ZStack{
            Image("HistoryList")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 120)
                .overlay(
                    HStack{
                        HStack{
                            Image("Picol\(c_type)1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                            Rectangle()
                                .background(.gray)
                                .frame(width: 3, height: 80)
                            
                            ZStack{
                                Text(user.character_name)
                                    .font(.system(size: 25))
                                    .multilineTextAlignment(.leading)
                                Rectangle()
                                    .frame(width: 130, height: 8)
                                    .foregroundColor(.red)
                                //写真の色を表示
                                    .padding(.top, 50.0)
                            }
                        }
                        Spacer()
                        
                        Image(systemName: "star")
                            .font(.system(size: 40))
                            .foregroundColor(.bgButton)
                            .onTapGesture {
                                print("star tapped")
                                characterViewModel.putDefaultCharacter(cid: String(user.cid)) {
                                    defaultCharacter = user.character_param
                                }
                            }
                    }.padding(.all, 30.0)
                )
        }.onAppear {
            c_type = typeCodeToTypeDic[user.character_param.first.map(String.init) ?? "1"] ?? "Fire"
            c_color = String(user.character_param.dropFirst())
        }
    }
}

#Preview {
    HistoryPreview(
        user: User(uid: 1, user_message: "こんにちは", cid: 1, character_name: "キャラクターネーム", character_param: "2ff00ff", character_aura_image: "")
    )
}
