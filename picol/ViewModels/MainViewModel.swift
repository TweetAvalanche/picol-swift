import SwiftUI

class MainViewModel: ObservableObject {
    @Published var type: String = "Fire"
    @Published var face: String = "Flash"
}
