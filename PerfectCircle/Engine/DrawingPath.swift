import CoreGraphics

struct DrawingPath {
    private(set) var points: [CGPoint] = []

    mutating func append(_ point: CGPoint) {
        points.append(point)
    }

    mutating func reset() {
        points.removeAll()
    }

    var isEmpty: Bool { points.isEmpty }
    var count: Int { points.count }
}
