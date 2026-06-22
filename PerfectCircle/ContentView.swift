import SwiftUI

struct ContentView: View {
    @State private var viewModel = GameViewModel()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                StatsBarView(stats: viewModel.stats)

                ZStack {
                    DrawingCanvasView(
                        points: viewModel.path.points,
                        onChanged: { viewModel.onDragChanged($0) },
                        onEnded: { viewModel.onDragEnded() }
                    )

                    if case .idle = viewModel.state {
                        InstructionView()
                            .transition(.opacity)
                    }

                    if case .scored(let score) = viewModel.state {
                        let delta = Int(((score - 0.5) * 200).rounded())
                        ScoreDisplayView(
                            score: score,
                            pointDelta: delta,
                            onReset: { viewModel.reset() }
                        )
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: stateKey)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .preferredColorScheme(.dark)
    }

    private var stateKey: String {
        switch viewModel.state {
        case .idle:    return "idle"
        case .drawing: return "drawing"
        case .scored:  return "scored"
        }
    }
}

#Preview {
    ContentView()
}
