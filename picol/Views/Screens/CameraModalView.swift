//
//  CameraModalView.swift
//  picol
//

import SwiftUI

struct CameraModalView: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var cameraService: CameraService
    @StateObject var characterViewModel = CharacterViewModel()
    @State private var name = ""
    @State private var favorite = false
    
    var body: some View {
        if let capturedImage = cameraService.capturedImage {
            ZStack {
                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
                if characterViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else if let user = characterViewModel.user {
                    VStack {
                        Text("新しいぴこるーを発見!")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                        Image("PicolFire")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .onTapGesture {
                                print("PicolFire tapped")
                            }
                        TextField("ぴこるーの名前を入力", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        HStack {
                            Button(action: {
                                favorite.toggle()
                            }) {
                                Image(systemName: favorite ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.title)
                                Text("お気に入り")
                                    .foregroundColor(.black)
                            }
                            .frame(width: 150, height: 50)
                            .background(Color.white)
                            .cornerRadius(10)
                            
                            Button(action: {
                                if name.isEmpty {
                                    return
                                }
                                
                                characterViewModel.characterRename(cid: String(user.cid), characterName: name) {
                                    print("Character renamed")
                                    dismiss()
                                }
                            }) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .font(.title)
                                Text("登録")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 100, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                            
                        }
                    }
                    .scaledToFit()
                    .backgroundColor("bgBlack0.5")
                }
            }.onAppear {
                characterViewModel.uploadImage(image: capturedImage) { result in
                    print("Image uploaded")
                    if let str = result {
                        print(str)
                    }
                }
            }
            .backgroundImage("MainBackground", darken: true)
            
        } else {
            ProgressView()
        }
    }
}

#Preview {
    CameraModalView(cameraService: CameraService())
}
