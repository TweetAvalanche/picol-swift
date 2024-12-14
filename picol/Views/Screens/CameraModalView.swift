//
//  CameraModalView.swift
//  picol
//

import SwiftUI

struct CameraModalView: View {
    @ObservedObject var cameraService: CameraService
    let uploadURL = URL(string: "https://p2flash.fynsv.net/character")!
    
    var body: some View {
        if let capturedImage = cameraService.capturedImage {
            ZStack {
                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }.onAppear {
                if 
            }
        } else {
            ProgressView()
        }
    }
}

#Preview {
    CameraModalView(cameraService: CameraService())
}
