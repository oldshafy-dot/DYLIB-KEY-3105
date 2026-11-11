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

            VStack(spacing: 0) {
                RoboMadeByBanner()
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                Spacer()

                VStack(spacing: 10) {
                    RoboTitle()

                    Text("3105")
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(uiColor: .label).opacity(0.75))

                    Text("License verified")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(uiColor: .label).opacity(0.55))
                }

                Spacer()
            }
        }
    }
}

private struct RoboMadeByBanner: View {
    private let roboOrange = Color(red: 1.0, green: 0.47, blue: 0.12)

    var body: some View {
        HStack {
            Text("Made by Shafay")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(roboOrange)

            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(height: 46)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(uiColor: .systemBackground).opacity(0.45))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(
                    Color(uiColor: .systemGray)
                        .opacity(0.35),
                    lineWidth: 1
                )
        )
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
