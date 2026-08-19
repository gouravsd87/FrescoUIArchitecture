import Foundation

public struct CartModel: Equatable, Sendable {
    public let itemCount: Int

    public init(itemCount: Int) {
        self.itemCount = itemCount
    }
}
