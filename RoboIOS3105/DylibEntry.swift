import Foundation

@_cdecl("RoboIOS3105DylibVersion")
public func RoboIOS3105DylibVersion() -> UnsafePointer<CChar> {
    static let version = strdup("3105")
    return UnsafePointer(version!)
}

@_cdecl("RoboIOS3105DylibInitialize")
public func RoboIOS3105DylibInitialize() {
    // Dynamic library initialization entry point.
}
