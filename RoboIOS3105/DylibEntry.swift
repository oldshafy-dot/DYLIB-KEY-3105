import Foundation

private let roboIOS3105Version = "3105"

@_cdecl("RoboIOS3105DylibVersion")
public func RoboIOS3105DylibVersion() -> UnsafePointer<CChar> {
    return strdup(roboIOS3105Version)!
}

@_cdecl("RoboIOS3105DylibInitialize")
public func RoboIOS3105DylibInitialize() {
    // Intentionally empty: initialization must not touch UIKit, networking,
    // threads, or other host-app state during dynamic loading.
}
