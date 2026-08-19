import Foundation

public enum AddToCartError: Error, Equatable, Sendable {
    case invalidQuantity
    case bagLimitReached
}
