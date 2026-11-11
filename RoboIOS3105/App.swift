import SwiftUI

@main
struct RoboIOS3105App: App {
    init() {
        guard DylibLoader.load() else {\n            fatalError("Required dylib is missing or could not be loaded")\n        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
