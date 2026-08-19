import Observation
import MenuServiceInterface
import FrescoUI

@Observable @MainActor
public final class ProductDetailViewProcessor: Processor<ProductDetailViewState, ProductDetailViewAction> {
    private let menuService: any MenuServiceInterface

    public init(product: ProductModel, menuService: any MenuServiceInterface) {
        self.menuService = menuService
        super.init(
            state: ProductDetailViewState(product: product),
            reducer: ProductDetailViewReducer()
        )
    }

    public override func process(_ action: ProductDetailViewAction) async -> ProductDetailViewAction? {
        switch action {
        case .appeared:
            let itemCount = await menuService.cartItemCount()
            return .bagCountSynced(itemCount)
        case .addToBag:
            return await addToBag()
        case .incrementQuantity, .decrementQuantity, .bagCountSynced,
             .itemAdded, .addFailed, .dismissMessage:
            return nil
        }
    }

    private func addToBag() async -> ProductDetailViewAction {
        do {
            let snapshot = try await menuService.validateAndAddToCart(
                productId: state.product.id,
                quantity: state.quantity
            )
            return .itemAdded(snapshot.itemCount)
        } catch let error as AddToCartError {
            return .addFailed(error)
        } catch {
            return .addFailed(.invalidQuantity)
        }
    }
}
