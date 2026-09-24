import SwiftUI

struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct AnswerWindowView: View {
    let answer: String
    let ballSize: CGFloat

    @State private var textSize: CGSize = .zero

    private var windowBlue: Color {
        Color(red: 0.09, green: 0.31, blue: 0.79)
    }

    private var fontSize: CGFloat {
        max(13, ballSize * 0.056)
    }

    private var textWidth: CGFloat {
        ballSize * 0.58
    }

    private var triangleWidth: CGFloat {
        max(textWidth + ballSize * 0.18, ballSize * 0.5)
    }

    private var triangleHeight: CGFloat {
        max(textSize.height, ballSize * 0.08) + ballSize * 0.55
    }

    var body: some View {
        Text(answer)
            .font(.system(size: fontSize, weight: .medium))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: textWidth)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear { textSize = proxy.size }
                        .onChange(of: proxy.size) { _, newValue in
                            textSize = newValue
                        }
                }
            )
            .padding(.bottom, ballSize * 0.06)
            .frame(width: triangleWidth, height: triangleHeight, alignment: .bottom)
            .background(
                TriangleShape()
                    .fill(windowBlue)
            )
    }
}

struct BallView: View {
    let answer: String?
    let rocking: Bool
    let rockStartDate: Date?
    let reduceMotion: Bool

    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion

    private var effectiveReduceMotion: Bool {
        reduceMotion || systemReduceMotion
    }

    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            let isRocking = rocking && !effectiveReduceMotion
            TimelineView(.animation(minimumInterval: nil, paused: !isRocking)) { timeline in
                ball(size: size)
                    .modifier(RockEffect(active: isRocking, start: rockStartDate ?? .now, date: timeline.date))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Magic 8 Ball")
        .accessibilityValue(answer ?? "")
    }

    private func ball(size: CGFloat) -> some View {
        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.55))
                .frame(width: size * 0.82, height: size * 0.14)
                .blur(radius: size * 0.035)
                .offset(y: size * 0.50)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(white: 0.38),
                            Color(white: 0.10),
                            Color(white: 0.0),
                        ],
                        center: UnitPoint(x: 0.35, y: 0.26),
                        startRadius: size * 0.02,
                        endRadius: size * 0.75
                    )
                )

            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.55), Color.white.opacity(0.0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.42, height: size * 0.20)
                .rotationEffect(.degrees(-18))
                .offset(x: -size * 0.16, y: -size * 0.27)
                .blur(radius: size * 0.015)

            Circle()
                .fill(Color(white: 0.93))
                .frame(width: size * 0.42)
                .offset(y: size * 0.02)

            Text("8")
                .font(.system(size: size * 0.30, weight: .bold, design: .rounded))
                .foregroundStyle(Color(white: 0.05))
                .offset(y: size * 0.035)

            if let answer {
                AnswerWindowView(answer: answer, ballSize: size)
                    .offset(y: size * 0.38)
            }
        }
        .frame(width: size, height: size)
        .compositingGroup()
    }
}

private struct RockEffect: ViewModifier {
    let active: Bool
    let start: Date
    let date: Date

    private let period: TimeInterval = 0.66
    private let angleAmplitude: Double = 7
    private let offsetAmplitude: CGFloat = 0.02

    func body(content: Content) -> some View {
        if active {
            let t = date.timeIntervalSince(start)
            let phase = sin(t * 2 * .pi / period)
            content
                .rotationEffect(.degrees(phase * angleAmplitude))
                .offset(x: phase * offsetAmplitude * 100)
        } else {
            content
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        BallView(answer: "Absolutely, unless you mess it up.", rocking: false, rockStartDate: nil, reduceMotion: false)
            .frame(width: 280, height: 280)
    }
    .preferredColorScheme(.dark)
}
