import SwiftUI

@MainActor
@Observable
final class BallModel {
    enum Phase {
        case idle
        case shaking
        case revealed
    }

    private(set) var phase: Phase = .idle
    private(set) var answer: String?
    private(set) var shakeStartDate: Date?

    private let engine: Magic8BallEngine
    private var shakeTask: Task<Void, Never>?

    init(engine: Magic8BallEngine = Magic8BallEngine(store: UserDefaultsDeckStateStore())) {
        self.engine = engine
    }

    func shake(reduceMotion: Bool) {
        guard phase == .idle else { return }
        if reduceMotion {
            answer = engine.drawSaying()
            phase = .revealed
        } else {
            phase = .shaking
            shakeStartDate = .now
            shakeTask = Task { [weak self] in
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                self?.reveal()
            }
        }
    }

    func askAgain() {
        shakeTask?.cancel()
        answer = nil
        shakeStartDate = nil
        phase = .idle
    }

    private func reveal() {
        answer = engine.drawSaying()
        phase = .revealed
    }
}

struct ContentView: View {
    @State private var model = BallModel()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            RadialGradient(
                colors: [Color(white: 0.11), Color(white: 0.03)],
                center: UnitPoint(x: 0.5, y: 0.32),
                startRadius: 10,
                endRadius: 520
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                BallView(
                    answer: model.answer,
                    rocking: model.phase == .shaking,
                    rockStartDate: model.shakeStartDate,
                    reduceMotion: reduceMotion
                )
                .frame(width: 280, height: 280)
                Spacer()
                actionButton
                    .frame(maxWidth: 300)
                    .padding(.bottom, 28)
            }
        }
        .preferredColorScheme(.dark)
        .statusBarHidden()
        .onDisappear {
            model.askAgain()
        }
    }

    @ViewBuilder
    private var actionButton: some View {
        switch model.phase {
        case .idle:
            ActionButton(title: "Shake the Ball") {
                model.shake(reduceMotion: reduceMotion)
            }
        case .shaking:
            ActionButton(title: "Shaking", action: {})
                .disabled(true)
        case .revealed:
            ActionButton(title: "Ask Again") {
                model.askAgain()
            }
        }
    }
}

struct ActionButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color(white: 0.92))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    Capsule()
                        .fill(Color(white: 0.10).opacity(0.6))
                )
                .overlay(
                    Capsule()
                        .strokeBorder(Color(white: 0.38), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

#Preview {
    ContentView()
}
