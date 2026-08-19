import Testing
@testable import MenuUI
import MenuServiceInterface

struct MenuViewReducerTests {
    @Test func appearedSetsLoading() {
        var state = MenuViewState()
        MenuViewReducer().update(&state, with: .appeared)
        #expect(state.isLoading == true)
        #expect(state.loadFailed == false)
    }

    @Test func menuLoadedWritesProductsAndBagCount() {
        var state = MenuViewState(isLoading: true)
        let products = SampleMenuCatalog().makeProducts()
        MenuViewReducer().update(&state, with: .menuLoaded(products: products, bagItemCount: 3))
        #expect(state.isLoading == false)
        #expect(state.products == products)
        #expect(state.bagItemCount == 3)
    }

    @Test func quickAddDoesNotMutateState() {
        var state = MenuViewState(products: SampleMenuCatalog().makeProducts())
        let before = state
        MenuViewReducer().update(&state, with: .quickAdd("wrap"))
        #expect(state == before)
    }

    @Test func itemAddedUpdatesCountAndMessage() {
        var state = MenuViewState()
        MenuViewReducer().update(&state, with: .itemAdded(2))
        #expect(state.bagItemCount == 2)
        #expect(state.statusMessage == "Added to bag")
    }

    @Test func selectProductSlicesFromLoadedList() {
        let products = SampleMenuCatalog().makeProducts()
        var state = MenuViewState(products: products)
        MenuViewReducer().update(&state, with: .selectProduct("taco"))
        #expect(state.selectedProduct?.id == "taco")
        MenuViewReducer().update(&state, with: .clearSelection)
        #expect(state.selectedProduct == nil)
    }
}
