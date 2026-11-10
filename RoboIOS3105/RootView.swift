import SwiftUI

struct RootView: View {
    @StateObject private var licenseManager = LicenseManager()

    var body: some View {
        Group {
            if licenseManager.isVerified {
                MainPlaceholderView()
            } else {
                LicenseView(manager: licenseManager)
            }
        }
        .task {
            await licenseManager.restoreAndValidate()
        }
    }
}

private struct MainPlaceholderView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            StarFieldView().opacity(0.35).ignoresSafeArea()

            VStack(spacing: 14) {
                RoboTitle()
                Text("3105")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
                Text("License verified")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }
}

struct RoboTitle: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("ROBO")
                .foregroundStyle(.white)
            Text(" iOS")
                .foregroundStyle(Color.red)
        }
        .font(.system(size: 42, weight: .black, design: .rounded))
        .tracking(-1.2)
    }
}
