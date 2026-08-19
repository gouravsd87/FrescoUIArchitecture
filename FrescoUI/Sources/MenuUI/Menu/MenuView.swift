import SwiftUI
import MenuServiceInterface

public struct MenuView: View {
    private let state: MenuViewState
    private let actionHandler: (MenuViewAction) -> Void
    private let translator = MenuTranslator()

    public init(state: MenuViewState, actionHandler: @escaping (MenuViewAction) -> Void) {
        self.state = state
        self.actionHandler = actionHandler
    }

    public var body: some View {
        Group {
            if state.isLoading && state.products.isEmpty {
                ProgressView("Loading menu")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if state.loadFailed && state.products.isEmpty {
                ContentUnavailableView {
                    Label("Menu unavailable", systemImage: "wifi.slash")
                } description: {
                    Text("Check the mock service, then try again.")
                } actions: {
                    Button("Retry") {
                        actionHandler(.retryLoad)
                    }
                }
            } else {
                productList
            }
        }
        .navigationTitle("Menu")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Text("Bag \(state.bagItemCount)")
                    .font(.subheadline.weight(.semibold))
                    .accessibilityLabel("Bag item count \(state.bagItemCount)")
            }
        }
        .onAppear {
            if state.products.isEmpty && !state.isLoading && !state.loadFailed {
                actionHandler(.appeared)
            }
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

    private var productList: some View {
        List(state.products) { product in
            ProductRowView(state: translator.rowState(from: product)) { rowAction in
                switch rowAction {
                case .select:
                    actionHandler(.selectProduct(product.id))
                case .quickAdd:
                    actionHandler(.quickAdd(product.id))
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview("Loaded") {
    NavigationStack {
        MenuView(
            state: MenuViewState(
                products: SampleMenuCatalog().makeProducts(),
                bagItemCount: 2
            ),
            actionHandler: { _ in }
        )
    }
}

#Preview("Loading") {
    NavigationStack {
        MenuView(state: MenuViewState(isLoading: true), actionHandler: { _ in })
    }
}
