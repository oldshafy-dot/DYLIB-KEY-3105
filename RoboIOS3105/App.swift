import SwiftUI

@main
struct RoboIOS3105App: App {
    init() {
        DylibLoader.load()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.dark)
        }
    }
}
