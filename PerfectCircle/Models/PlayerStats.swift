import Foundation

struct PlayerStats: Codable {
    var attempts: Int = 0
    var totalRawScore: Double = 0.0
    var cumulativePoints: Int = 0

    var averageAccuracy: Double {
        attempts > 0 ? totalRawScore / Double(attempts) : 0
    }

    var rank: Rank {
        RankCalculator.rank(for: self)
    }

    mutating func record(score: Double) {
        attempts += 1
        totalRawScore += score
        let delta = (score - 0.5) * 200
        cumulativePoints += Int(delta.rounded())
    }
}
