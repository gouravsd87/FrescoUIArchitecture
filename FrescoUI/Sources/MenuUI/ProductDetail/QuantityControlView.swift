import SwiftUI

struct QuantityControlView: View {
    struct ViewState: Equatable {
        let quantity: Int
        let isDecrementEnabled: Bool
        let isIncrementEnabled: Bool
    }

    enum Action: Equatable {
        case decrement
        case increment
    }

    private enum Const {
        static let controlSpacing: CGFloat = 16
        static let quantityLabelMinWidth: CGFloat = 28
    }

    private let state: ViewState
    private let actionHandler: (Action) -> Void

    init(state: ViewState, actionHandler: @escaping (Action) -> Void) {
        self.state = state
        self.actionHandler = actionHandler
    }

    var body: some View {
        HStack(spacing: Const.controlSpacing) {
            Button {
                actionHandler(.decrement)
            } label: {
                Image(systemName: "minus.circle.fill")
                    .font(.title2)
            }
            .disabled(!state.isDecrementEnabled)
            .accessibilityLabel("Decrease quantity")

            Text("\(state.quantity)")
                .font(.title3.monospacedDigit().weight(.semibold))
                .frame(minWidth: Const.quantityLabelMinWidth)
                .accessibilityLabel("Quantity \(state.quantity)")

            Button {
                actionHandler(.increment)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
            .disabled(!state.isIncrementEnabled)
            .accessibilityLabel("Increase quantity")
        }
    }
}

#Preview {
    QuantityControlView(
        state: .init(quantity: 2, isDecrementEnabled: true, isIncrementEnabled: true),
        actionHandler: { _ in }
    )
}
