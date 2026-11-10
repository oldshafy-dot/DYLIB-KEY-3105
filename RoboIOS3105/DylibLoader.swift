import Foundation
import Darwin

enum DylibLoader {
    static func load() {
        let path = Bundle.main.privateFrameworksPath.map {
            URL(fileURLWithPath: $0).appendingPathComponent("RoboIOS3105Dylib.dylib").path
        }

        guard let path else {
            return
        }

        _ = dlopen(path, RTLD_NOW | RTLD_LOCAL)
    }
}
