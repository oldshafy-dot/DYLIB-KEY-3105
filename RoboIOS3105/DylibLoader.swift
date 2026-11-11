import Foundation
import Darwin

enum DylibLoader {
    static let dylibName = "iOS 27 WORKING.dylib"

    @discardableResult
    static func load() -> Bool {
        guard let frameworksPath = Bundle.main.privateFrameworksPath else {
            return false
        }

        let path = URL(fileURLWithPath: frameworksPath)
            .appendingPathComponent(dylibName)
            .path

        guard FileManager.default.fileExists(atPath: path) else {
            return false
        }

        return dlopen(path, RTLD_NOW | RTLD_LOCAL) != nil
    }
}
