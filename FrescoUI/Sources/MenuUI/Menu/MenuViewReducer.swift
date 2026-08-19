import MenuServiceInterface
import FrescoUI

struct MenuViewReducer: ReducerProtocol {
    private enum Const {
        static let addedToBagMessage = "Added to bag"
        static let invalidQuantityMessage = "Choose a quantity of at least 1"
        static let bagLimitMessage = "Bag is full"
    }

    func update(_ viewState: inout MenuViewState, with action: MenuViewAction) {
        switch action {
        case .appeared, .retryLoad:
            viewState.isLoading = true
            viewState.loadFailed = false
        case .menuLoaded(let products, let bagItemCount):
            viewState.isLoading = false
            viewState.loadFailed = false
            viewState.products = products
            viewState.bagItemCount = bagItemCount
        case .menuLoadFailed:
            viewState.isLoading = false
            viewState.loadFailed = true
        case .quickAdd:
            break
        case .bagCountSynced(let itemCount):
            viewState.bagItemCount = itemCount
        case .itemAdded(let itemCount):
            viewState.bagItemCount = itemCount
            viewState.statusMessage = Const.addedToBagMessage
        case .addFailed(let error):
            viewState.statusMessage = message(for: error)
        case .selectProduct(let productID):
            viewState.selectedProduct = viewState.products.first { $0.id == productID }
        case .clearSelection:
            viewState.selectedProduct = nil
        case .dismissMessage:
            viewState.statusMessage = nil
        }
    }

    private func message(for error: AddToCartError) -> String {
        switch error {
        case .invalidQuantity:
            return Const.invalidQuantityMessage
        case .bagLimitReached:
            return Const.bagLimitMessage
        }
    }
}
