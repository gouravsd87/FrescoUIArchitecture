import Foundation
import MenuServiceInterface

/// In-memory `MenuServiceInterface`. Catalog and bag live here so MenuUI
/// processors never take a second service. Replace with `MenuService` later.
public actor MockMenuService: MenuServiceInterface {
    public enum Const {
        public static let defaultDelay = Duration.milliseconds(450)
        public static let defaultMaxItemCount = 10
        public static let minimumAddQuantity = 1
    }

    private let products: [ProductModel]
    private let delay: Duration
    private let shouldFail: Bool
    private var itemCount: Int
    private let maxItemCount: Int

    public init(
        products: [ProductModel] = SampleMenuCatalog().makeProducts(),
        delay: Duration = Const.defaultDelay,
        shouldFail: Bool = false,
        initialItemCount: Int = 0,
        maxItemCount: Int = Const.defaultMaxItemCount
    ) {
        self.products = products
        self.delay = delay
        self.shouldFail = shouldFail
        itemCount = initialItemCount
        self.maxItemCount = maxItemCount
    }

    public func getProducts() async throws -> [ProductModel] {
        try await Task.sleep(for: delay)
        if shouldFail {
            throw MenuLoadError.unavailable
        }
        return products
    }

    public func validateAndAddToCart(productId: ProductModel.ID, quantity: Int) async throws -> CartModel {
        _ = productId
        try await Task.sleep(for: delay)
        guard quantity >= Const.minimumAddQuantity else {
            throw AddToCartError.invalidQuantity
        }
        let nextCount = itemCount + quantity
        guard nextCount <= maxItemCount else {
            throw AddToCartError.bagLimitReached
        }
        itemCount = nextCount
        return CartModel(itemCount: itemCount)
    }

    public func cartItemCount() async -> Int {
        itemCount
    }
}

public struct SampleMenuCatalog: Sendable {
    public enum Const {
        public static let sampleMinimumQuantity = 1
        public static let sampleMaximumQuantity = 10
    }

    public init() {}

    public func makeCrispyWrap(
        minimumQuantity: Int = Const.sampleMinimumQuantity,
        maximumQuantity: Int = Const.sampleMaximumQuantity
    ) -> ProductModel {
        makeProduct(
            id: "wrap",
            name: "Crispy Wrap",
            summary: "Crunchy shell, seasoned filling, shredded lettuce.",
            formattedPrice: "$4.29",
            minimumQuantity: minimumQuantity,
            maximumQuantity: maximumQuantity
        )
    }

    public func makeProducts() -> [ProductModel] {
        [
            makeCrispyWrap(),
            makeProduct(
                id: "taco",
                name: "Street Taco",
                summary: "Soft tortilla, salsa, onions, cilantro.",
                formattedPrice: "$2.49"
            ),
            makeProduct(
                id: "bowl",
                name: "Rice Bowl",
                summary: "Rice, beans, roasted vegetables, lime crema.",
                formattedPrice: "$7.99"
            ),
            makeProduct(
                id: "cooler",
                name: "Citrus Cooler",
                summary: "Sparkling citrus over ice.",
                formattedPrice: "$2.19"
            )
        ]
    }

    private func makeProduct(
        id: String,
        name: String,
        summary: String,
        formattedPrice: String,
        minimumQuantity: Int = Const.sampleMinimumQuantity,
        maximumQuantity: Int = Const.sampleMaximumQuantity
    ) -> ProductModel {
        ProductModel(
            id: id,
            name: name,
            summary: summary,
            formattedPrice: formattedPrice,
            minimumQuantity: minimumQuantity,
            maximumQuantity: maximumQuantity
        )
    }
}
