//
//  FlashReceiver.swift
//  picol
//

import AVFoundation
import UIKit

class FlashReceiver: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    // MARK: - Properties
    @Published var isSessionRunning = false
    @Published var progress: Double = 0.0
    @Published var statusText: String = "起動中..."
    @Published var fps: Double = 0.0
    @Published var processingTime: Double = 0.0
    @Published var lastReceivedData: String = ""
    @Published var isFinish: Bool = false
    @Published var receivedUserData: User?
    @Published var isFlash: Bool = false

    private let tokenViewModel = TokenViewModel()

    // セッション関連
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "touch.session.queue")

    private var device: AVCaptureDevice?
    private let videoDataOutput = AVCaptureVideoDataOutput()

    // データ処理用
    private let startPattern = [1,0,1,0,1,0,1,0]  // 8bit
    private let dataBitCount = 29
    private let bitDuration: Double = 0.1  // 100ms per bit
    private let luminanceThreshold: CGFloat = 0.85
    private let framesPerBit: Int = 3
    private let initialFrameCount = 30

    private var frameCount = 0
    private var startFrameBuffer: [Bool] = []
    private var isReceivingData = false
    private var startAccuracyList: [Double] = [0.0, 0.0, 0.0]
    private var dataFrameBuffer: [Bool] = []
    private var dataBitBuffer: [Bool] = []
    private var maxLuminance: CGFloat = 0.0
    private var lastFrameTime: CMTime = CMTime.invalid

    // MARK: - Initialization
    override init() {
        super.init()
        configureSession()
    }

    func configureSession() {
        sessionQueue.async {
            self.session.beginConfiguration()
            self.session.sessionPreset = .low

            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                self.session.commitConfiguration()
                return
            }

            self.device = device

            do {
                try device.lockForConfiguration()
                if device.isExposureModeSupported(.custom) {
                    let exposureDuration = device.activeFormat.minExposureDuration
                    device.setExposureModeCustom(duration: exposureDuration, iso: device.iso, completionHandler: nil)
                }
                // フレームレートを30fpsに設定
                device.activeVideoMinFrameDuration = CMTime(value: 1, timescale: 30)
                device.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: 30)
                device.unlockForConfiguration()
            } catch {
                self.session.commitConfiguration()
                return
            }

            guard let input = try? AVCaptureDeviceInput(device: device) else {
                self.session.commitConfiguration()
                return
            }

            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }

            self.videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInitiated)
            self.videoDataOutput.setSampleBufferDelegate(self, queue: videoQueue)

            if self.session.canAddOutput(self.videoDataOutput) {
                self.session.addOutput(self.videoDataOutput)
            }

            self.session.commitConfiguration()
        }
    }

    func startSession() {
        sessionQueue.async {
            if self.session.isRunning { return }
            self.configureSession()
            self.session.startRunning()
            Task { @MainActor in
                self.statusText = "読み込み中..."
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

    func getSession() -> AVCaptureSession {
        return session
    }

    func getLuminance() -> CGFloat {
        return maxLuminance
    }

    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let startTime = CFAbsoluteTimeGetCurrent()

        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)

        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let yStride = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0)
        guard let yPlane = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0) else { return }

        let squareSize = min(width, height)
        let xOffset = (width - squareSize) / 2
        let yOffset = (height - squareSize) / 2

        maxLuminance = 0.0

        for y in 0..<squareSize {
            let rowPtr = yPlane + (y + yOffset) * yStride
            for x in 0..<squareSize {
                let pixel = rowPtr.advanced(by: (x + xOffset)).assumingMemoryBound(to: UInt8.self)
                let luminance = CGFloat(pixel.pointee) / 255.0
                if luminance > maxLuminance {
                    maxLuminance = luminance
                }
            }
        }

        CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)

        let currentTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        updateFPS(currentTime)
        updateProcessingTime(startTime)

        DispatchQueue.main.async {
            self.processLuminance(self.maxLuminance)
        }
    }

    // MARK: - Data Processing
    private func processLuminance(_ luminance: CGFloat) {
        frameCount += 1
        if frameCount < initialFrameCount {
            updateStatusText("初期化中...")
            return
        }

        let isBright = luminance > luminanceThreshold
        updateFlash(isBright)
        updateStatusText(isReceivingData ? "受信中..." : "スタートパターン検知前")

        if !isReceivingData {
            startFrameBuffer.append(isBright)
            let accuracy = calculateStartPatternAccuracy()
            startAccuracyList.removeFirst()
            startAccuracyList.append(accuracy)

            if startAccuracyList[0] > 0.0 {
                let maxIndex = startAccuracyList.firstIndex(of: startAccuracyList.max()!)!
                let tmpBuffer = startFrameBuffer.suffix(2 - maxIndex)
                dataFrameBuffer.append(contentsOf: tmpBuffer)

                isReceivingData = true
                startFrameBuffer = []
                startAccuracyList = [0.0, 0.0, 0.0]
            }
        } else {
            dataFrameBuffer.append(isBright)

            if dataFrameBuffer.count > framesPerBit {
                dataFrameBuffer = []
                isReceivingData = false
                return
            }

            if dataFrameBuffer.count == framesPerBit {
                let brightCount = dataFrameBuffer.filter{$0}.count
                let bitPattern = (brightCount > framesPerBit/2)
                dataBitBuffer.append(bitPattern)
                dataFrameBuffer = []

                DispatchQueue.main.async {
                    self.progress = Double(self.dataBitBuffer.count) / Double(self.dataBitCount)
                }

                if dataBitBuffer.count == dataBitCount {
                    isReceivingData = false
                    let decodedBit = decode(dataBitBuffer)
                    let hexData = bitToHex(decodedBit)
                    updateLastReceivedData(hexData)
                    tokenViewModel.loadToken(token: hexData) {
                        print("loadToken completion")
                        if let user = self.tokenViewModel.receivedUser {
                            print("token user sucsses")
                            print(user)
                            self.receivedUserData = user
                            self.updateFinish()
                        } else {
                            print("loadToken")
                        }
                    }
                    dataBitBuffer = []
                }
            }
        }
    }

    // スタートパターン精度計算
    private func calculateStartPatternAccuracy() -> Double {
        let startFrameCount = startPattern.count * framesPerBit
        if startFrameBuffer.count < startFrameCount { return 0.0 }

        startFrameBuffer = Array(startFrameBuffer.suffix(startFrameCount))
        var missCount = 0

        for i in 0..<startFrameCount {
            if i % framesPerBit == 0 {
                let targetPattern = startPattern[i / framesPerBit] == 1
                let bitBuffer = Array(startFrameBuffer[i..<i+framesPerBit])
                let brightCount = bitBuffer.filter{$0}.count
                let bitPattern = (brightCount > framesPerBit/2)

                if targetPattern != bitPattern { return 0.0 }

                for bit in bitBuffer {
                    if bit != targetPattern {
                        missCount += 1
                    }
                }
            }
        }

        let accuracy = 1.0 - Double(missCount) / Double(startFrameCount)
        return accuracy
    }

    private func decode(_ encodedBits: [Bool]) -> [Bool] {
        var encodedBits = encodedBits
        // パリティチェック
        let parityPositions: [Int] = [1,2,4,8,16]
        var errorPosition = 0
        for p in parityPositions {
            var parity = false
            for i in 1...29 {
                if (i & p) != 0 {
                    parity = parity != encodedBits[i - 1]
                }
            }
            // パリティがずれていれば、そのパリティビット位置をerrorPositionにXOR加算
            if parity {
                errorPosition ^= p
            }
        }

        // エラー訂正(もしerrorPositionが0でなければ、そのビットを反転)
        if errorPosition != 0 && errorPosition <= 29 {
            encodedBits[errorPosition - 1].toggle()
        }

        // 復元するデータビットを抽出
        let paritySet = Set(parityPositions)
        var decodedBits: [Bool] = []
        for i in 1...29 {
            if !paritySet.contains(i) {
                decodedBits.append(encodedBits[i - 1])
            }
        }
        print("decode: \(decodedBits)")
        return decodedBits
    }

    private func bitToHex(_ bits: [Bool]) -> String {
        let binaryString = bits.map { $0 ? "1" : "0" }.joined()
        guard let decimal = Int(binaryString, radix: 2) else {
            print("Invalid data: \(bits)")
            return ""
        }
        return String(format: "%06X", decimal)
    }

    // MARK: - Debug / UI Update
    func updateFPS(_ currentTime: CMTime) {
        if lastFrameTime.isValid {
            let duration = CMTimeSubtract(currentTime, lastFrameTime)
            let fpsVal = 1.0 / CMTimeGetSeconds(duration)
            DispatchQueue.main.async {
                self.fps = fpsVal
            }
        }
        lastFrameTime = currentTime
    }

    func updateProcessingTime(_ startTime: CFAbsoluteTime) {
        let endTime = CFAbsoluteTimeGetCurrent()
        let processingDuration = endTime - startTime
        DispatchQueue.main.async {
            self.processingTime = processingDuration
        }
    }

    func updateStatusText(_ text: String) {
        DispatchQueue.main.async {
            self.statusText = text
        }
    }

    func updateLastReceivedData(_ hexData: String) {
        DispatchQueue.main.async {
            self.lastReceivedData = hexData
        }
    }
    
    func updateFlash(_ isBright: Bool) {
        DispatchQueue.main.async {
            self.isFlash = isBright
        }
    }
        
    func updateFinish() {
        DispatchQueue.main.async {
            self.isFinish = true
        }
    }
}
