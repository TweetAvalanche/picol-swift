//
//  HistoryListView.swift
//  picol
//
//  Created by 遠藤七佳 on 2024/12/15.
//

import SwiftUI

struct HistoryListView: View {
    @FocusState var isFocused: Bool
    var body: some View {
        ZStack{
            Image("HistoryList")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 120)
                .overlay(
                    HStack{
                        HStack{
//                            Circle()
////                                .foregroundColor(.red)
//                                .frame(width: 70, height: 70)
                            Image("PicolFire1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                            Rectangle()
                                .background(.gray)
                                .frame(width: 3, height: 80)
                            
                            ZStack{
                                Text("キャラクタ名")
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
                                
                            }
                    }.padding(.all, 30.0)
                )
        }
    }
}

#Preview {
    HistoryListView()
}
