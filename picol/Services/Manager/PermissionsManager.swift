//
//  PermissionsManager.swift
//  picol
//

import Foundation
import AVFoundation

@MainActor
class PermissionsManager: ObservableObject {
    @Published var isCameraAuthorized: Bool = false
    @Published var showCameraAccessAlert: Bool = false
    @Published var cameraAccessError: String = ""
    
    /// カメラ使用許可をリクエストする関数
    func requestCameraAuthorization() async {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isCameraAuthorized = true
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            isCameraAuthorized = granted
            if !granted {
                cameraAccessError = "カメラへのアクセスが拒否されました。設定から変更してください。"
                showCameraAccessAlert = true
            }
        default:
            isCameraAuthorized = false
            cameraAccessError = "カメラへのアクセスが拒否されました。設定から変更してください。"
            showCameraAccessAlert = true
        }
    }
}
