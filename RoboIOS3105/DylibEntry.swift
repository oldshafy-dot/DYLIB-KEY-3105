import Foundation

private let roboIOS3105Version = "3105"

@_cdecl("RoboIOS3105DylibVersion")
public func RoboIOS3105DylibVersion() -> UnsafePointer<CChar> {
    let pointer = strdup(roboIOS3105Version)!
    return UnsafePointer(pointer)
}

@_cdecl("RoboIOS3105DylibInitialize")
public func RoboIOS3105DylibInitialize() {
    // Intentionally empty. Keep dylib startup lightweight and deterministic.
}
