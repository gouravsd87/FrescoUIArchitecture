import SwiftUI
import MenuServiceInterface
import FrescoUI

/// Hosts the menu processor and pushes product detail with its own processor.
/// Both processors share one `MenuServiceInterface` instance.
public struct MenuRootView: View {
    private let menuService: any MenuServiceInterface

    public init(menuService: any MenuServiceInterface = MockMenuService()) {
        self.menuService = menuService
    }

    public var body: some View {
        WithProcessor({
            MenuViewProcessor(menuService: menuService)
        }) { menuProcessor in
            NavigationStack {
                MenuView(
                    state: menuProcessor.state,
                    actionHandler: { menuProcessor.send($0) }
                )
                .navigationDestination(
                    item: menuProcessor.makeBinding(\.selectedProduct) { product in
                        if let product {
                            return .selectProduct(product.id)
                        }
                        return .clearSelection
                    }
                ) { product in
                    ProductDetailContainer(product: product, menuService: menuService)
                }
            }
        }
    }
}

private struct ProductDetailContainer: View {
    let product: ProductModel
    let menuService: any MenuServiceInterface

    var body: some View {
        WithProcessor({
            ProductDetailViewProcessor(product: product, menuService: menuService)
        }) { processor in
            ProductDetailView(
                state: processor.state,
                actionHandler: { processor.send($0) }
            )
        }
    }
}

private enum PreviewConst {
    static let serviceDelay = Duration.milliseconds(200)
}

#Preview("Sample app") {
    MenuRootView(
        menuService: MockMenuService(delay: PreviewConst.serviceDelay)
    )
}
