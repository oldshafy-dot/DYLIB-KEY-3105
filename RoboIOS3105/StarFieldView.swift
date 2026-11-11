import SwiftUI

struct StarFieldView: View {
    private let stars: [Star] = (0..<90).map { _ in
        Star(
            x: .random(in: 0...1),
            startY: .random(in: 0...1),
            radius: .random(in: 0.8...2.0),
            speed: .random(in: 0.035...0.10),
            opacity: .random(in: 0.35...0.85)
        )
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let isDark = UITraitCollection.current.userInterfaceStyle == .dark
                let starColor = isDark ? Color.white : Color.black
                let t = CGFloat(timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 12.0))

                for star in stars {
                    let y = ((star.startY + t * star.speed).truncatingRemainder(dividingBy: 1.12)) - 0.06
                    let rect = CGRect(
                        x: star.x * size.width,
                        y: y * size.height,
                        width: star.radius,
                        height: star.radius
                    )
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(starColor.opacity(star.opacity))
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }

    private struct Star {
        let x: CGFloat
        let startY: CGFloat
        let radius: CGFloat
        let speed: CGFloat
        let opacity: Double
    }
}
