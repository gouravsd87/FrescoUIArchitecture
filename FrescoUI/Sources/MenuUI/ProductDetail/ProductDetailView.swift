import SwiftUI
import MenuServiceInterface

public struct ProductDetailView: View {
    private enum Const {
        static let contentSpacing: CGFloat = 20
        static let headerSpacing: CGFloat = 8
    }

    private let state: ProductDetailViewState
    private let actionHandler: (ProductDetailViewAction) -> Void
    private let translator = ProductDetailTranslator()

    public init(
        state: ProductDetailViewState,
        actionHandler: @escaping (ProductDetailViewAction) -> Void
    ) {
        self.state = state
        self.actionHandler = actionHandler
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Const.contentSpacing) {
            VStack(alignment: .leading, spacing: Const.headerSpacing) {
                Text(state.product.name)
                    .font(.largeTitle.weight(.bold))
                Text(state.product.summary)
                    .font(.body)
                    .foregroundStyle(.secondary)
                Text(state.product.formattedPrice)
                    .font(.title3.weight(.semibold))
            }

            QuantityControlView(state: translator.quantityState(from: state)) { action in
                switch action {
                case .decrement:
                    actionHandler(.decrementQuantity)
                case .increment:
                    actionHandler(.incrementQuantity)
                }
            }

            Spacer()

            AddToBagButtonView(state: translator.addButtonState(from: state)) { action in
                switch action {
                case .tapped:
                    actionHandler(.addToBag)
                }
            }
        }
        .padding()
        .navigationTitle("Item")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Text("Bag \(state.bagItemCount)")
                    .font(.subheadline.weight(.semibold))
            }
        }
        .onAppear {
            actionHandler(.appeared)
        }
        .alert(
            "Bag",
            isPresented: Binding(
                get: { state.statusMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        actionHandler(.dismissMessage)
                    }
                }
            ),
            actions: {
                Button("OK") {
                    actionHandler(.dismissMessage)
                }
            },
            message: {
                Text(state.statusMessage ?? "")
            }
        )
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(
            state: ProductDetailViewState(
                product: SampleMenuCatalog().makeCrispyWrap(),
                quantity: 2,
                bagItemCount: 1
            ),
            actionHandler: { _ in }
        )
    }
}
