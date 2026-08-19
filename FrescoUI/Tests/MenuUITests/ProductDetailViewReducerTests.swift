import Testing
@testable import MenuUI
import MenuServiceInterface

struct ProductDetailViewReducerTests {
    @Test func quantityChangesAreSynchronousAndClamped() {
        let product = SampleMenuCatalog().makeCrispyWrap()
        var state = ProductDetailViewState(product: product, quantity: 1)
        let reducer = ProductDetailViewReducer()

        reducer.update(&state, with: .decrementQuantity)
        #expect(state.quantity == product.minimumQuantity)

        reducer.update(&state, with: .incrementQuantity)
        #expect(state.quantity == 2)
    }

    @Test func incrementStopsAtTheProductMaximum() {
        let product = SampleMenuCatalog().makeCrispyWrap(maximumQuantity: 3)
        var state = ProductDetailViewState(
            product: product,
            quantity: product.maximumQuantity
        )

        ProductDetailViewReducer().update(&state, with: .incrementQuantity)

        #expect(state.quantity == product.maximumQuantity)
        #expect(state.isIncrementEnabled == false)
    }

    @Test func addToBagSetsAddingBeforeServiceReturns() {
        let product = SampleMenuCatalog().makeCrispyWrap()
        var state = ProductDetailViewState(product: product)
        ProductDetailViewReducer().update(&state, with: .addToBag)
        #expect(state.isAdding == true)
    }

    @Test func itemAddedClearsAddingAndShowsConfirmation() {
        let product = SampleMenuCatalog().makeCrispyWrap()
        var state = ProductDetailViewState(product: product, isAdding: true)
        ProductDetailViewReducer().update(&state, with: .itemAdded(4))
        #expect(state.isAdding == false)
        #expect(state.bagItemCount == 4)
        #expect(state.statusMessage == "Added to bag")
    }

    @Test func addFailedSurfacesBagLimit() {
        let product = SampleMenuCatalog().makeCrispyWrap()
        var state = ProductDetailViewState(product: product, isAdding: true)
        ProductDetailViewReducer().update(&state, with: .addFailed(.bagLimitReached))
        #expect(state.isAdding == false)
        #expect(state.statusMessage == "Bag is full")
    }
}
