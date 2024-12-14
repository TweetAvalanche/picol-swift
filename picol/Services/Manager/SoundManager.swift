import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var bgmPlayer: AVAudioPlayer?
    private var sePlayer: AVAudioPlayer?
    
    func playBGM(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            return
        }
        
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: url)
            bgmPlayer?.numberOfLoops = -1
            bgmPlayer?.volume = 0.5
            bgmPlayer?.play()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func stopBGM() {
        bgmPlayer?.stop()
    }

    func playSE(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            return
        }
        
        do {
            sePlayer = try AVAudioPlayer(contentsOf: url)
            sePlayer?.play()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
