import SwiftUI

struct StatsBarView: View {
    let stats: PlayerStats

    private var rankColor: Color {
        switch stats.rank {
        case .novice:  return .gray
        case .amateur: return Color(red: 0.6, green: 0.4, blue: 0.2)
        case .skilled: return .blue
        case .expert:  return .purple
        case .master:  return .orange
        case .legend:  return .yellow
        }
    }

    private var pointsText: String {
        let sign = stats.cumulativePoints >= 0 ? "+" : ""
        return "\(sign)\(stats.cumulativePoints)"
    }

    var body: some View {
        HStack {
            Label(stats.rank.rawValue, systemImage: "star.fill")
                .font(.subheadline.bold())
                .foregroundStyle(rankColor)

            Spacer()

            Text(pointsText)
                .font(.subheadline.bold())
                .foregroundStyle(stats.cumulativePoints >= 0 ? .green : .red)
                .contentTransition(.numericText())

            Spacer()

            Text("\(stats.attempts) attempts")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(.black.opacity(0.3))
    }
}
