import SwiftUI
import MenuServiceInterface

struct ProductRowView: View {
    struct ViewState: Equatable {
        let id: ProductModel.ID
        let name: String
        let summary: String
        let formattedPrice: String
    }

    enum Action: Equatable {
        case select
        case quickAdd
    }

    private enum Const {
        static let rowSpacing: CGFloat = 12
        static let textSpacing: CGFloat = 4
        static let verticalPadding: CGFloat = 8
    }

    private let state: ViewState
    private let actionHandler: (Action) -> Void

    init(state: ViewState, actionHandler: @escaping (Action) -> Void) {
        self.state = state
        self.actionHandler = actionHandler
    }

    var body: some View {
        HStack(alignment: .top, spacing: Const.rowSpacing) {
            VStack(alignment: .leading, spacing: Const.textSpacing) {
                Text(state.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(state.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                Text(state.formattedPrice)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture {
                actionHandler(.select)
            }
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel(state.name)

            Button("Add") {
                actionHandler(.quickAdd)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityLabel("Quick add \(state.name)")
        }
        .padding(.vertical, Const.verticalPadding)
    }
}

#Preview {
    ProductRowView(
        state: .init(
            id: "wrap",
            name: "Crispy Wrap",
            summary: "Crunchy shell, seasoned filling.",
            formattedPrice: "$4.29"
        ),
        actionHandler: { _ in }
    )
    .padding()
}
