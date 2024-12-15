//
//  HistoryListView.swift
//  picol
//
//  Created by 遠藤七佳 on 2024/12/15.
//

import SwiftUI

struct HistoryListView: View {
    @FocusState var isFocused: Bool
    @StateObject var characterViewModel = CharacterViewModel()

    var body: some View {
        VStack {
            if !characterViewModel.isLoading {
                // characterViewModel.charactersをループで回してHistoryPreviewを表示
                Text("今まで見つけたぴこるー")
                    .font(.custom("BestTenDOT", size: 28))
                    .foregroundColor(.white)
                    .padding(.vertical, 5.0)
                ScrollView {
                    LazyVStack {
                        ForEach(characterViewModel.characterList, id: \.cid) { character in
                            HistoryPreview(user: character)
                        }
                    }
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
            
        }.onAppear {
            characterViewModel.getAllCharacter {
                print("キャラクター取得完了")
            }
        }
        .backgroundColor("bgTitleColorOff")
    }
}

#Preview {
    HistoryListView()
}
