import SwiftUI
import Firebase

@main
struct SimpleRegisterApp: App {
    @StateObject var dataManager = DataManager()  // Initialize dataManager

    init() {
        FirebaseApp.configure()  // Configure Firebase
    }

    var body: some Scene {
        WindowGroup {
            // Pass dataManager to the environment of the root view
            ContentView()
                .environmentObject(dataManager)  // Make sure it's injected
        }
    }
}
