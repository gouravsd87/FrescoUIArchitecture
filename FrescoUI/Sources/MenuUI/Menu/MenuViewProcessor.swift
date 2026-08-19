import Observation
import MenuServiceInterface
import FrescoUI

@Observable @MainActor
public final class MenuViewProcessor: Processor<MenuViewState, MenuViewAction> {
    private enum Const {
        static let defaultQuantity = 1
    }

    private let menuService: any MenuServiceInterface

    public init(menuService: any MenuServiceInterface) {
        self.menuService = menuService
        super.init(state: MenuViewState(), reducer: MenuViewReducer())
    }

    public override func process(_ action: MenuViewAction) async -> MenuViewAction? {
        switch action {
        case .appeared, .retryLoad:
            return await loadMenu()
        case .quickAdd(let productID):
            return await addToBag(productID: productID, quantity: Const.defaultQuantity)
        case .menuLoaded, .menuLoadFailed, .bagCountSynced, .itemAdded, .addFailed,
             .selectProduct, .clearSelection, .dismissMessage:
            return nil
        }
    }

    private func loadMenu() async -> MenuViewAction {
        do {
            let products = try await menuService.getProducts()
            let bagItemCount = await menuService.cartItemCount()
            return .menuLoaded(products: products, bagItemCount: bagItemCount)
        } catch {
            return .menuLoadFailed
        }
    }

    private func addToBag(productID: ProductModel.ID, quantity: Int) async -> MenuViewAction {
        do {
            let snapshot = try await menuService.validateAndAddToCart(
                productId: productID,
                quantity: quantity
            )
            return .itemAdded(snapshot.itemCount)
        } catch let error as AddToCartError {
            return .addFailed(error)
        } catch {
            return .addFailed(.invalidQuantity)
        }
    }
}
