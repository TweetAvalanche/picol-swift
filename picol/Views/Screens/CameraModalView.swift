//
//  CameraModalView.swift
//  picol
//

import SwiftUI

struct CameraModalView: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var cameraService: CameraService
    @StateObject private var viewModel = PicolImageViewModel()
    @StateObject var characterViewModel = CharacterViewModel()
    @State private var name = ""
    @State private var favorite = false
    
    @AppStorage("defaultCharacter") var defaultCharacter = "2ffffff"
    
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
                            .font(.custom("BestTenDOT", size: 32))
                            .foregroundColor(.white)
                            .padding()
                        PicolImage()
                            .environmentObject(viewModel)
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
                                
                                characterViewModel.characterRename(cid: String(user.cid), characterName: name, isDefault: favorite) {
                                    print("Character renamed")
                                    if favorite {
                                        print("defaultCharacter = \(defaultCharacter)↓")
                                        defaultCharacter = user.character_param
                                        print("defaultCharacter = \(defaultCharacter)↓")
                                    }
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
                    if let user = result {
                        viewModel.getTypeFromParam(param: user.character_param)
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
