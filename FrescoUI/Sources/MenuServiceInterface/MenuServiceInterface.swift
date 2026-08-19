import Foundation

/// The only service boundary MenuUI processors talk to.
///
/// A later `MenuService` package can implement this for a real backend.
/// Live bag updates from other screens (typically an `AsyncStream` in Cart UI)
/// are intentionally out of scope for this sample.
public protocol MenuServiceInterface: Sendable {
    func getProducts() async throws -> [ProductModel]
    func validateAndAddToCart(productId: ProductModel.ID, quantity: Int) async throws -> CartModel
    func cartItemCount() async -> Int
}

public enum MenuLoadError: Error, Sendable {
    case unavailable
}
