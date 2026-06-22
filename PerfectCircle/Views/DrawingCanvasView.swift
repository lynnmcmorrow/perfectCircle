import SwiftUI

struct DrawingCanvasView: View {
    var points: [CGPoint]
    var onChanged: (CGPoint) -> Void
    var onEnded: () -> Void

    var body: some View {
        Canvas { context, _ in
            guard points.count >= 2 else { return }
            var path = Path()
            path.move(to: points[0])
            for point in points.dropFirst() {
                path.addLine(to: point)
            }
            context.stroke(path, with: .color(.white), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged { onChanged($0.location) }
                .onEnded { _ in onEnded() }
        )
    }
}
