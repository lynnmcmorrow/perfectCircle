import SwiftUI

@Observable
final class GameViewModel {
    var state: GameState = .idle
    var path: DrawingPath = DrawingPath()
    var stats: PlayerStats = StatsStore.load()

    func onDragChanged(_ point: CGPoint) {
        if case .idle = state { state = .drawing }
        path.append(point)
    }

    func onDragEnded() {
        guard case .drawing = state else { return }
        if let score = CircleScorer.score(path) {
            stats.record(score: score)
            StatsStore.save(stats)
            state = .scored(score)
        } else {
            state = .idle
        }
        path.reset()
    }

    func reset() {
        state = .idle
        path.reset()
    }
}
