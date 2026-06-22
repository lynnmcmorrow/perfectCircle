import Foundation

enum Rank: String, CaseIterable {
    case novice   = "Novice"
    case amateur  = "Amateur"
    case skilled  = "Skilled"
    case expert   = "Expert"
    case master   = "Master"
    case legend   = "Legend"

    var color: String {
        switch self {
        case .novice:  return "gray"
        case .amateur: return "brown"
        case .skilled: return "blue"
        case .expert:  return "purple"
        case .master:  return "orange"
        case .legend:  return "yellow"
        }
    }
}

enum RankCalculator {
    static func rank(for stats: PlayerStats) -> Rank {
        let composite = stats.averageAccuracy * min(1.0, Double(stats.attempts) / 50.0) * 100
        switch composite {
        case 85...: return .legend
        case 70..<85: return .master
        case 55..<70: return .expert
        case 40..<55: return .skilled
        case 20..<40: return .amateur
        default:      return .novice
        }
    }
}
