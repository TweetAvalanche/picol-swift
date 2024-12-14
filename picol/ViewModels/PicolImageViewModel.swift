import SwiftUI

class PicolImageViewModel: ObservableObject {
    @Published var type: String = "Fire"
    @Published var face: String = "Angry"
    let faces = ["Fine", "Flash", "Sad", "", "Heart", "Angry"]
    let typeCodeToTypeDic = ["1": "Fire", "2": "Star", "3": "Moon", "4": "Light", "5": "Bulb", "6": "Sun"]

    func getTypeFromParam(param: String) {
        let typeCode = param.count < 1 ? "1" : param.prefix(1)
        self.type = typeCodeToTypeDic[String(typeCode)]!
    }

    func changeType(type: String) {
        self.type = type
    }

    func changeFace(face: String) {
        self.face = face
    }
}
