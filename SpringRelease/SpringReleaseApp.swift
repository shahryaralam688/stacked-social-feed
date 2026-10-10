import SwiftUI

@main
struct SpringReleaseApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(.light)
        }
    }
}
