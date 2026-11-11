import SwiftUI

struct RootView: View {
    var body: some View {
        MainPlaceholderView()
    }
}

private struct MainPlaceholderView: View {
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            StarFieldView()
                .ignoresSafeArea()

            VStack(spacing: 10) {
                RoboTitle()

                Text("3105")
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(uiColor: .label).opacity(0.75))

                Text("License verified")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(uiColor: .label).opacity(0.55))
            }
        }
    }
}

struct RoboTitle: View {
    private let roboOrange = Color(red: 1.0, green: 0.47, blue: 0.12)

    var body: some View {
        Text("ROBO iOS")
            .foregroundStyle(roboOrange)
            .font(.system(size: 46, weight: .heavy, design: .rounded))
            .tracking(-1.0)
    }
}
