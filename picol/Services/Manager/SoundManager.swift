import AVFoundation

class ScreenManager {
    // ...existing code...
    
    var audioPlayer: AVAudioPlayer?
    let screenBGM: [String: String] = [
        "HomeScreen": "home_bgm.mp3",
        "GameScreen": "game_bgm.mp3",
        "SettingsScreen": "settings_bgm.mp3"
        // 他のスクリーンとBGMのペアをここに追加
    ]
    
    func showScreen(screenName: String) {
        // ...existing code...
        playBGM(for: screenName)
        // ...existing code...
    }
    
    func playBGM(for screenName: String) {
        guard let bgmFileName = screenBGM[screenName] else { return }
        let path = Bundle.main.path(forResource: bgmFileName, ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Could not play BGM for \(screenName): \(error)")
        }
    }
    
    func stopBGM() {
        audioPlayer?.stop()
    }
}
