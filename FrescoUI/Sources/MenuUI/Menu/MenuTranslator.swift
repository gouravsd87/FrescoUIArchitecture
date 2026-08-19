import Foundation
import MenuServiceInterface

struct MenuTranslator {
    func rowState(from product: ProductModel) -> ProductRowView.ViewState {
        ProductRowView.ViewState(
            id: product.id,
            name: product.name,
            summary: product.summary,
            formattedPrice: product.formattedPrice
        )
    }
}
