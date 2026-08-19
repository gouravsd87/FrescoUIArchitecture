import Foundation
import MenuServiceInterface

public struct ProductDetailViewState: Equatable, Sendable {
    public var product: ProductModel
    public var quantity: Int
    public var isAdding: Bool
    public var bagItemCount: Int
    public var statusMessage: String?

    public init(
        product: ProductModel,
        quantity: Int? = nil,
        isAdding: Bool = false,
        bagItemCount: Int = 0,
        statusMessage: String? = nil
    ) {
        self.product = product
        self.quantity = quantity ?? product.minimumQuantity
        self.isAdding = isAdding
        self.bagItemCount = bagItemCount
        self.statusMessage = statusMessage
    }

    var isDecrementEnabled: Bool { quantity > product.minimumQuantity }
    var isIncrementEnabled: Bool { quantity < product.maximumQuantity }
}

public enum ProductDetailViewAction: Equatable, Sendable {
    case appeared
    case incrementQuantity
    case decrementQuantity
    case addToBag
    case bagCountSynced(Int)
    case itemAdded(Int)
    case addFailed(AddToCartError)
    case dismissMessage
}
