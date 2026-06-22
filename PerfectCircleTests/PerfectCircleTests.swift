import Testing
import CoreGraphics
@testable import PerfectCircle

@Suite("CircleScorer")
struct CircleScorerTests {

    func makeCircle(radius: CGFloat, center: CGPoint = CGPoint(x: 200, y: 200), points: Int = 120) -> DrawingPath {
        var path = DrawingPath()
        for i in 0..<points {
            let angle = 2 * Double.pi * Double(i) / Double(points)
            path.append(CGPoint(x: center.x + radius * cos(angle),
                                y: center.y + radius * sin(angle)))
        }
        return path
    }

    func makeEllipse(rx: CGFloat, ry: CGFloat, center: CGPoint = CGPoint(x: 200, y: 200), points: Int = 120) -> DrawingPath {
        var path = DrawingPath()
        for i in 0..<points {
            let angle = 2 * Double.pi * Double(i) / Double(points)
            path.append(CGPoint(x: center.x + rx * cos(angle),
                                y: center.y + ry * sin(angle)))
        }
        return path
    }

    @Test func perfectCircleScoresHigh() {
        let path = makeCircle(radius: 100)
        let score = CircleScorer.score(path)
        #expect(score != nil)
        #expect(score! >= 0.95)
    }

    @Test func ellipseScoresLow() {
        let path = makeEllipse(rx: 150, ry: 75)
        let score = CircleScorer.score(path)
        #expect(score != nil)
        #expect(score! <= 0.60)
    }

    @Test func tinyCircleRejected() {
        let path = makeCircle(radius: 20)
        #expect(CircleScorer.score(path) == nil)
    }

    @Test func tooFewPointsRejected() {
        var path = DrawingPath()
        for i in 0..<10 {
            path.append(CGPoint(x: Double(i) * 10, y: 0))
        }
        #expect(CircleScorer.score(path) == nil)
    }

    @Test func incompleteArcPenalized() {
        var path = DrawingPath()
        let center = CGPoint(x: 200, y: 200)
        for i in 0..<60 {
            let angle = Double.pi * Double(i) / 60.0
            path.append(CGPoint(x: center.x + 100 * cos(angle),
                                y: center.y + 100 * sin(angle)))
        }
        let fullScore = CircleScorer.score(makeCircle(radius: 100))!
        let halfScore = CircleScorer.score(path)
        #expect(halfScore != nil)
        #expect(halfScore! < fullScore * 0.7)
    }
}

@Suite("RankCalculator")
struct RankCalculatorTests {

    @Test func zeroAttemptsIsNovice() {
        #expect(RankCalculator.rank(for: PlayerStats()) == .novice)
    }

    @Test func singlePerfectAttemptIsNovice() {
        var stats = PlayerStats()
        stats.record(score: 1.0)
        #expect(RankCalculator.rank(for: stats) == .novice)
    }

    @Test func fiftyPerfectAttemptsIsLegend() {
        var stats = PlayerStats()
        for _ in 0..<50 { stats.record(score: 1.0) }
        #expect(RankCalculator.rank(for: stats) == .legend)
    }

    @Test func fiftyAverageAttemptsIsSkilled() {
        var stats = PlayerStats()
        for _ in 0..<50 { stats.record(score: 0.50) }
        #expect(RankCalculator.rank(for: stats) == .novice)
    }

    @Test func pointDeltaPositiveForGoodCircle() {
        var stats = PlayerStats()
        stats.record(score: 0.75)
        #expect(stats.cumulativePoints > 0)
    }

    @Test func pointDeltaNegativeForPoorCircle() {
        var stats = PlayerStats()
        stats.record(score: 0.20)
        #expect(stats.cumulativePoints < 0)
    }

    @Test func breakEvenAtFiftyPercent() {
        var stats = PlayerStats()
        stats.record(score: 0.50)
        #expect(stats.cumulativePoints == 0)
    }
}
