//
//  CameraService.swift
//  picol
//

import AVFoundation
import UIKit

class CameraService: NSObject, ObservableObject {
    @Published var isAuthorized = false
    @Published var capturedImage: UIImage?
    @Published var isSessionRunning = false
    
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    private let photoOutput = AVCapturePhotoOutput()
    private var videoDeviceInput: AVCaptureDeviceInput?
    
    override init() {
        super.init()
    }
    
    // MARK: - Permissions
    func requestAuthorization() async {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            await MainActor.run {
                self.isAuthorized = true
            }
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            await MainActor.run {
                self.isAuthorized = granted
            }
        default:
            await MainActor.run {
                self.isAuthorized = false
            }
        }
    }
    
    // MARK: - Session Control
    func getSession() -> AVCaptureSession {
        return session
    }
    
    func configureSession() {
        sessionQueue.async {
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo
            
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                self.session.commitConfiguration()
                return
            }
            
            do {
                let deviceInput = try AVCaptureDeviceInput(device: device)
                if self.session.canAddInput(deviceInput) {
                    self.session.addInput(deviceInput)
                    self.videoDeviceInput = deviceInput
                }
                
                if self.session.canAddOutput(self.photoOutput) {
                    self.session.addOutput(self.photoOutput)
                }
                
                self.session.commitConfiguration()
            } catch {
                print("Failed to configure camera: \(error)")
                self.session.commitConfiguration()
            }
        }
    }
    
    func startSession() {
        sessionQueue.async {
            if self.session.isRunning { return }
            self.session.startRunning()
            Task { @MainActor in
                self.isSessionRunning = true
            }
        }
    }
    
    func stopSession() {
        sessionQueue.async {
            if !self.session.isRunning { return }
            self.session.stopRunning()
            Task { @MainActor in
                self.isSessionRunning = false
            }
        }
    }
    
    // MARK: - Photo Capture
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .off
        self.photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraService: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }
        
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            print("No photo data or unable to create UIImage")
            return
        }
        
        // メインスレッドでUI更新
        Task { @MainActor in
            self.capturedImage = image
        }
    }
}
