import SwiftUI

struct StarFieldView: View {
    private let stars: [Star] = (0..<95).map { _ in
        Star(x: .random(in: 0...1), y: .random(in: 0...1), radius: .random(in: 0.5...1.7), opacity: .random(in: 0.18...0.7))
    }

    var body: some View {
        GeometryReader { proxy in
            Canvas { context, size in
                for star in stars {
                    let rect = CGRect(
                        x: star.x * size.width,
                        y: star.y * size.height,
                        width: star.radius,
                        height: star.radius
                    )
                    context.fill(Path(ellipseIn: rect), with: .color(.white.opacity(star.opacity)))
                }
            }
            .blur(radius: 0.25)
            .background(.black)
        }
    }

    private struct Star {
        let x: CGFloat
        let y: CGFloat
        let radius: CGFloat
        let opacity: Double
    }
}
