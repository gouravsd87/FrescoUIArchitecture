import Testing
@testable import MenuUI
import MenuServiceInterface

@MainActor
struct ProductDetailViewProcessorTests {
    @Test func incrementDoesNotCallAddToCart() async {
        let product = SampleMenuCatalog().makeCrispyWrap()
        let menuService = MockMenuService(delay: .zero, initialItemCount: 0)
        let processor = ProductDetailViewProcessor(product: product, menuService: menuService)

        await processor.sendAsync(.incrementQuantity)

        #expect(processor.state.quantity == 2)
        let itemCount = await menuService.cartItemCount()
        #expect(itemCount == 0)
    }

    @Test func addToBagWritesThroughMenuService() async {
        let product = SampleMenuCatalog().makeCrispyWrap()
        let processor = ProductDetailViewProcessor(
            product: product,
            menuService: MockMenuService(delay: .zero)
        )
        await processor.sendAsync(.incrementQuantity)
        await processor.sendAsync(.addToBag)

        #expect(processor.state.isAdding == false)
        #expect(processor.state.bagItemCount == 2)
        #expect(processor.state.statusMessage == "Added to bag")
    }

    @Test func appearedReadsBagCountWithoutToast() async {
        let product = SampleMenuCatalog().makeCrispyWrap()
        let processor = ProductDetailViewProcessor(
            product: product,
            menuService: MockMenuService(delay: .zero, initialItemCount: 5)
        )

        await processor.sendAsync(.appeared)

        #expect(processor.state.bagItemCount == 5)
        #expect(processor.state.statusMessage == nil)
    }
}
