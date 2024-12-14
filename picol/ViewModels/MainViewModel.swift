import SwiftUI

class MainViewModel: ObservableObject {
    @Published var type: String = "Fire"
    @Published var face: String = "Angry"
    let faces = ["Fine", "Flash", "Sad", "", "Heart", "Angry"]

    func changeType(type: String) {
        self.type = type
    }

    func changeFace(face: String) {
        self.face = face
    }
}
