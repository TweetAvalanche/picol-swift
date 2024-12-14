//
//  CameraModalView.swift
//  picol
//

import SwiftUI

struct CameraModalView: View {
    @ObservedObject var cameraService: CameraService
    @StateObject var imageViewModel = ImageViewModel()
    @State private var name = ""
    @State private var favorite = false
    
    var body: some View {
        if let capturedImage = cameraService.capturedImage {
            ZStack {
                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
                if imageViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    VStack {
                        Text("ぴこるーを発見!")
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
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: {
                                print("登録")
                            }) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .font(.title)
                                Text("登録")
                            }
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            
                        }
                    }
                    .scaledToFit()
                    .backgroundColor("bgBlack0.5")
                }
            }.onAppear {
                imageViewModel.uploadImage(image: capturedImage) { result in
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
