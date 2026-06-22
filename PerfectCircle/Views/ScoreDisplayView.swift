import SwiftUI

struct ScoreDisplayView: View {
    let score: Double
    let pointDelta: Int
    let onReset: () -> Void

    @State private var displayedScore: Int = 0

    private var targetScore: Int { Int((score * 100).rounded()) }

    private var scoreColor: Color {
        switch targetScore {
        case 70...: return .green
        case 40..<70: return .yellow
        default:    return .red
        }
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("\(displayedScore)%")
                .font(.system(size: 88, weight: .bold, design: .rounded))
                .foregroundStyle(scoreColor)
                .contentTransition(.numericText())
                .animation(.easeOut(duration: 0.8), value: displayedScore)

            let sign = pointDelta >= 0 ? "+" : ""
            Text("\(sign)\(pointDelta) pts")
                .font(.title2.bold())
                .foregroundStyle(pointDelta >= 0 ? .green : .red)

            Button(action: onReset) {
                Text("Try Again")
                    .font(.headline)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(.white.opacity(0.15))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                displayedScore = targetScore
            }
        }
    }
}
