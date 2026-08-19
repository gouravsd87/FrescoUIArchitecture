import SwiftUI

struct AddToBagButtonView: View {
    struct ViewState: Equatable {
        let title: String
        let isDisabled: Bool
    }

    enum Action: Equatable {
        case tapped
    }

    private let state: ViewState
    private let actionHandler: (Action) -> Void

    init(state: ViewState, actionHandler: @escaping (Action) -> Void) {
        self.state = state
        self.actionHandler = actionHandler
    }

    var body: some View {
        Button(state.title) {
            actionHandler(.tapped)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(state.isDisabled)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    AddToBagButtonView(
        state: .init(title: "Add to bag", isDisabled: false),
        actionHandler: { _ in }
    )
    .padding()
}
