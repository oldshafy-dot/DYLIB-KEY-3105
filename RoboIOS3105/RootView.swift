import SwiftUI

struct RootView: View {
    var body: some View {
        MainPlaceholderView()
            .preferredColorScheme(nil)
    }
}

private struct MainPlaceholderView: View {
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            StarFieldView()
                .opacity(0.18)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                RoboTitle()

                Text("3105")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(uiColor: .label).opacity(0.72))

                Text("License verified")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(uiColor: .label).opacity(0.52))
            }
        }
    }
}

struct RoboTitle: View {
    private let sunsetOrange = Color(red: 1.0, green: 0.36, blue: 0.0)

    var body: some View {
        Text("ROBO iOS")
            .foregroundStyle(sunsetOrange)
            .font(.system(size: 42, weight: .black, design: .rounded))
            .tracking(-1.2)
    }
}
