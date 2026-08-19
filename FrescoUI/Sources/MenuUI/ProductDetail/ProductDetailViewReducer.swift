import MenuServiceInterface
import FrescoUI

struct ProductDetailViewReducer: ReducerProtocol {
    private enum Const {
        static let addedToBagMessage = "Added to bag"
        static let invalidQuantityMessage = "Choose a quantity of at least 1"
        static let bagLimitMessage = "Bag is full"
    }

    func update(_ viewState: inout ProductDetailViewState, with action: ProductDetailViewAction) {
        switch action {
        case .appeared:
            break
        case .incrementQuantity:
            guard viewState.quantity < viewState.product.maximumQuantity else {
                return
            }
            viewState.quantity += 1
        case .decrementQuantity:
            guard viewState.quantity > viewState.product.minimumQuantity else {
                return
            }
            viewState.quantity -= 1
        case .addToBag:
            viewState.isAdding = true
        case .bagCountSynced(let itemCount):
            viewState.bagItemCount = itemCount
        case .itemAdded(let itemCount):
            viewState.isAdding = false
            viewState.bagItemCount = itemCount
            viewState.statusMessage = Const.addedToBagMessage
        case .addFailed(let error):
            viewState.isAdding = false
            viewState.statusMessage = message(for: error)
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
