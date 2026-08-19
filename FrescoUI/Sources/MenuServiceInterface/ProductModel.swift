import Foundation

public struct ProductModel: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let summary: String
    public let formattedPrice: String
    public let minimumQuantity: Int
    public let maximumQuantity: Int

    public init(
        id: String,
        name: String,
        summary: String,
        formattedPrice: String,
        minimumQuantity: Int,
        maximumQuantity: Int
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.formattedPrice = formattedPrice
        self.minimumQuantity = minimumQuantity
        self.maximumQuantity = maximumQuantity
    }
}
