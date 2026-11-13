import SwiftUI
import UIKit

struct LicenseView: View {
    @ObservedObject var manager: LicenseManager
    @State private var key = ""
    @FocusState private var focused: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            StarFieldView().ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer(minLength: 42)

                    RoboTitle()

                    Text("This 3105 is made by Shafay")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.72))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                        .padding(.top, 18)

                    VStack(spacing: 12) {
                        TextField("VIP-XXXX-XXXX-XXXX-XXXX", text: $key)
                            .textInputAutocapitalization(.characters)
                            .autocorrectionDisabled()
                            .keyboardType(.asciiCapable)
                            .focused($focused)
                            .padding(.horizontal, 16)
                            .frame(height: 52)
                            .background(.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(.white.opacity(0.12), lineWidth: 1)
                            }
                            .foregroundStyle(.white)

                        Button {
                            focused = false
                            Task { await manager.verify(key: key) }
                        } label: {
                            HStack(spacing: 9) {
                                if manager.isVerifying {
                                    ProgressView()
                                        .tint(.white)
                                }
                                Text(manager.isVerifying ? "Verifying..." : "VERIFY")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .foregroundStyle(.white)
                            .background(Color.red, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .disabled(manager.isVerifying || key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .opacity(key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.45 : 1)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 28)

                    if let error = manager.errorMessage {
                        Text(error)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.red.opacity(0.95))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .padding(.top, 14)
                    }

                    Spacer(minLength: 42)

                    Button {
                        guard let url = URL(string: "https://t.me/+MFbTlA2W7Vk4NmU1") else { return }
                        UIApplication.shared.open(url)
                    } label: {
                        Text("Join Official Channel")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))
                            .padding(.horizontal, 16)
                            .frame(height: 38)
                            .background(.white.opacity(0.06), in: Capsule())
                    }
                    .padding(.bottom, 22)
                }
                .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height - 1)
            }
        }
    }
}
