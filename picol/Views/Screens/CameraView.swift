//
//  CameraView.swift
//  picol
//

import SwiftUI

struct CameraView: View {
    @StateObject var cameraService = CameraService()
    @State private var showingImagePreview = false
    
    var body: some View {
        ZStack {
            VStack{
                Spacer()
                GeometryReader { geometry in
                    CameraPreview(session: cameraService.getSession())
                        .aspectRatio(2/3, contentMode: .fit)
                        .overlay(
                            VStack{
                                Spacer()
                                Button(action: {
                                    if cameraService.isAuthorized {
                                        cameraService.capturePhoto()
                                        showingImagePreview = true
                                    }
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
                                        .padding(.bottom, 15.0)
                                }
                            }
                        )
                        .padding(10)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                            .padding(.top, 40)
//                Spacer()
            }
//
//            .padding(.bottom, 50.0)
//            Spacer()
        }
        .backgroundImage("CameraBackground")
        .sheet(isPresented: $showingImagePreview) {
            CameraModalView(cameraService: cameraService)
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

#Preview {
    CameraView()
}