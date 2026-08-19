import Testing
@testable import MenuUI
import MenuServiceInterface

@MainActor
struct MenuViewProcessorTests {
    @Test func appearedLoadsMenuThroughService() async {
        let catalog = SampleMenuCatalog().makeProducts()
        let processor = MenuViewProcessor(
            menuService: MockMenuService(products: catalog, delay: .zero, initialItemCount: 2)
        )

        await processor.sendAsync(.appeared)

        #expect(processor.state.isLoading == false)
        #expect(processor.state.products == catalog)
        #expect(processor.state.bagItemCount == 2)
    }

    @Test func appearedRecordsLoadFailure() async {
        let processor = MenuViewProcessor(
            menuService: MockMenuService(delay: .zero, shouldFail: true)
        )

        await processor.sendAsync(.appeared)

        #expect(processor.state.loadFailed == true)
        #expect(processor.state.products.isEmpty)
    }

    @Test func quickAddUpdatesBagCount() async {
        let processor = MenuViewProcessor(
            menuService: MockMenuService(delay: .zero)
        )
        await processor.sendAsync(.appeared)
        await processor.sendAsync(.quickAdd("wrap"))

        #expect(processor.state.bagItemCount == 1)
        #expect(processor.state.statusMessage == "Added to bag")
    }

    @Test func quickAddSurfacesBagLimitFromMenuService() async {
        let processor = MenuViewProcessor(
            menuService: MockMenuService(
                delay: .zero,
                initialItemCount: MockMenuService.Const.defaultMaxItemCount
            )
        )
        await processor.sendAsync(.appeared)
        await processor.sendAsync(.quickAdd("wrap"))

        #expect(processor.state.bagItemCount == MockMenuService.Const.defaultMaxItemCount)
        #expect(processor.state.statusMessage == "Bag is full")
    }
}
