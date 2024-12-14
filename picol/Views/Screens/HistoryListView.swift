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
                            VStack{
                                Text("キャラクタ名")
                                    .font(.system(size: 24))
                                Text("発見日")
                                    .font(.system(size: 12))
                                Text("0000.00.00")
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
