import CoreGraphics

enum CircleScorer {
    static let minimumRadius: CGFloat = 40
    static let cvMultiplier: Double = 3.0
    static let completenessThreshold: Double = 330 * .pi / 180

    static func score(_ path: DrawingPath) -> Double? {
        guard path.count >= 20 else { return nil }

        let centroid = centroid(of: path.points)
        let radii = path.points.map { hypot($0.x - centroid.x, $0.y - centroid.y) }

        let meanR = radii.reduce(0.0, +) / Double(radii.count)
        guard meanR >= minimumRadius else { return nil }

        let variance = radii.map { ($0 - meanR) * ($0 - meanR) }.reduce(0.0, +) / Double(radii.count)
        let stdDev = sqrt(variance)

        let filtered = radii.filter { abs($0 - meanR) <= 2 * stdDev }
        guard !filtered.isEmpty else { return nil }

        let filteredMean = filtered.reduce(0.0, +) / Double(filtered.count)
        let filteredVariance = filtered.map { ($0 - filteredMean) * ($0 - filteredMean) }.reduce(0.0, +) / Double(filtered.count)
        let filteredStdDev = sqrt(filteredVariance)
        let cv = filteredStdDev / filteredMean

        var rawScore = max(0.0, min(1.0, 1.0 - cv * cvMultiplier))

        let coverage = angularCoverage(of: path.points, centroid: centroid)
        if coverage < completenessThreshold {
            rawScore *= coverage / (2 * .pi)
        }

        return rawScore
    }

    private static func centroid(of points: [CGPoint]) -> CGPoint {
        let sumX = points.reduce(0.0) { $0 + $1.x }
        let sumY = points.reduce(0.0) { $0 + $1.y }
        return CGPoint(x: sumX / Double(points.count), y: sumY / Double(points.count))
    }

    private static func angularCoverage(of points: [CGPoint], centroid: CGPoint) -> Double {
        let angles = points.map { atan2($0.y - centroid.y, $0.x - centroid.x) }
        let sorted = angles.sorted()
        guard sorted.count >= 2 else { return 0 }

        var maxGap = 0.0
        for i in 0..<(sorted.count - 1) {
            maxGap = max(maxGap, sorted[i + 1] - sorted[i])
        }
        let wrapGap = (sorted.first! + 2 * .pi) - sorted.last!
        maxGap = max(maxGap, wrapGap)

        return max(0, 2 * .pi - maxGap)
    }
}
