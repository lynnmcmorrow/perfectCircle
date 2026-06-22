import SwiftUI

struct InstructionView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "hand.draw")
                .font(.system(size: 44))
                .foregroundStyle(.white.opacity(0.6))
            Text("Draw a perfect circle")
                .font(.title3)
                .foregroundStyle(.white.opacity(0.6))
        }
        .allowsHitTesting(false)
    }
}
