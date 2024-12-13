//
//  CameraView.swift
//  picol
//

import SwiftUI

struct CameraView: View {
    @StateObject var cameraService = CameraService()
    @State private var showingImagePreview = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if cameraService.isAuthorized {
                    VStack {
                        Spacer()
                        
                        // 16:9アスペクト比でカメラプレビューを表示
                        CameraPreview(session: cameraService.getSession())
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 16 / 9 * 0.8)
                            .clipped()
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        Spacer()
                        
                        // シャッターボタン
                        Button(action: {
                            cameraService.capturePhoto()
                        }) {
                            Circle()
                                .stroke(lineWidth: 5)
                                .foregroundColor(.white)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 60, height: 60)
                                )
                        }
                        .padding(.bottom, 40)
                    }
                    
                    // 撮影後の画像プレビュー表示
                    if let capturedImage = cameraService.capturedImage {
                        Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                        
                        VStack {
                            Spacer()
                            
                            Image(uiImage: capturedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.8)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                                .padding()
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    cameraService.capturedImage = nil
                                }) {
                                    Text("閉じる")
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(8)
                                }
                                .padding(.trailing, 20)
                            }
                            .padding()
                        }
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("カメラへのアクセスが許可されていません。設定から変更してください。")
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    }
                }
            }
            .onAppear {
                // カメラセッションの開始
                if cameraService.isAuthorized {
                    cameraService.configureSession()
                    cameraService.startSession()
                }
            }
            .onDisappear {
                // カメラセッションの停止
                cameraService.stopSession()
            }
            .task {
                // カメラ権限のリクエスト
                await cameraService.requestAuthorization()
                if cameraService.isAuthorized {
                    cameraService.configureSession()
                    cameraService.startSession()
                }
            }
        }
    }
}

#Preview {
    CameraView()
}
