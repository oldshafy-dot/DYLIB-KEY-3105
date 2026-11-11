import Foundation
import Darwin

enum DylibLoader {
    static func load() {
        let path = Bundle.main.privateFrameworksPath.map {
            URL(fileURLWithPath: $0).appendingPathComponent("iOS 27 WORKING.dylib").path
        }

        guard let path else {
            return
        }

        _ = dlopen(path, RTLD_NOW | RTLD_LOCAL)
    }
}
