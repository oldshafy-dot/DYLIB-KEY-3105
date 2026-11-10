import Foundation

private let roboIOS3105Version: [CChar] = Array("3105".utf8CString)

@_cdecl("RoboIOS3105DylibVersion")
public func RoboIOS3105DylibVersion() -> UnsafePointer<CChar> {
    return roboIOS3105Version.withUnsafeBufferPointer { buffer in
        buffer.baseAddress!
    }
}

@_cdecl("RoboIOS3105DylibInitialize")
public func RoboIOS3105DylibInitialize() {
    // Dynamic library initialization entry point.
}
