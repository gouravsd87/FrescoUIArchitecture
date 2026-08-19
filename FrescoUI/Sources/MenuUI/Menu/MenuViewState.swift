import Foundation
import MenuServiceInterface

public struct MenuViewState: Equatable, Sendable {
    public var isLoading: Bool
    public var loadFailed: Bool
    public var products: [ProductModel]
    public var bagItemCount: Int
    public var selectedProduct: ProductModel?
    public var statusMessage: String?

    public init(
        isLoading: Bool = false,
        loadFailed: Bool = false,
        products: [ProductModel] = [],
        bagItemCount: Int = 0,
        selectedProduct: ProductModel? = nil,
        statusMessage: String? = nil
    ) {
        self.isLoading = isLoading
        self.loadFailed = loadFailed
        self.products = products
        self.bagItemCount = bagItemCount
        self.selectedProduct = selectedProduct
        self.statusMessage = statusMessage
    }
}

public enum MenuViewAction: Equatable, Sendable {
    case appeared
    case retryLoad
    case menuLoaded(products: [ProductModel], bagItemCount: Int)
    case menuLoadFailed
    case quickAdd(ProductModel.ID)
    case bagCountSynced(Int)
    case itemAdded(Int)
    case addFailed(AddToCartError)
    case selectProduct(ProductModel.ID)
    case clearSelection
    case dismissMessage
}
