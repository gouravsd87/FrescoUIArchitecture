import Foundation

struct ProductDetailTranslator {
    private enum Const {
        static let addingTitle = "Adding…"
        static let addToBagTitle = "Add to bag"
    }

    func quantityState(from state: ProductDetailViewState) -> QuantityControlView.ViewState {
        QuantityControlView.ViewState(
            quantity: state.quantity,
            isDecrementEnabled: state.isDecrementEnabled,
            isIncrementEnabled: state.isIncrementEnabled
        )
    }

    func addButtonState(from state: ProductDetailViewState) -> AddToBagButtonView.ViewState {
        AddToBagButtonView.ViewState(
            title: state.isAdding ? Const.addingTitle : Const.addToBagTitle,
            isDisabled: state.isAdding
        )
    }
}
