# FrescoUI sample

A small, open-source-ready SwiftUI sample of the **FrescoUI** loop:

**View → Action → Processor → Reducer → ViewState → View**

This folder is self-contained. Copy `Samples/FrescoUI/` out of the parent repo to publish it.

For the long-form write-up of *why* the loop is shaped this way, read [`ARTICLE.md`](ARTICLE.md).

## Scope

This sample is **MenuUI only**.

- Processors depend on **one** type: `MenuServiceInterface`.
- `MockMenuService` implements that protocol (catalog + in-memory bag).
- A real `MenuService` package can replace the mock later.
- Live bag updates from other tabs (`AsyncStream` in Cart UI) are **not** shown here. Add-to-bag results come back as follow-up actions from `validateAndAddToCart`.

## What it demonstrates

1. **Menu list** loads products through `MenuServiceInterface.getProducts()`.
2. **Quick add** calls `validateAndAddToCart` on that same interface.
3. **Product detail** is a second processor, still injected with `MenuServiceInterface` only. Quantity is **synchronous**. Add to bag is **asynchronous**.
4. Bag-limit failures are follow-up actions; the reducer turns them into UI copy.

Numeric and copy constants use a caseless `enum Const`. Nested `Const` on a public type is `public` when used as a default argument. Per-item quantity bounds live on `ProductModel` (`minimumQuantity`, `maximumQuantity`) so a later service can map them from the catalog.

## Architecture

```text
View (state + actionHandler)
        │ Action
        ▼
   Processor.send
        │
        ├─ 1. Reducer.update  (sync, pure)  → ViewState
        │
        └─ 2. process(_:)     (async)       → MenuServiceInterface
                │
                └─ send(follow-up Action)   → reducer again
```

| Type | Responsibility | Must not |
| --- | --- | --- |
| **View** | Layout, gestures, accessibility | Business rules, services, holding `Processor` |
| **ViewState** | Data the screen needs to draw | Property wrappers, side effects |
| **Action** | User intent or a result from the world | Calling services |
| **Reducer** | `update(&state, with:)` | Network, persistence, `async` |
| **Processor** | `send` + `process` | Assigning `state` fields; talking to more than one service |
| **MenuServiceInterface** | Menu load, add to cart, one-shot bag count | UI types |

### Child views

`ProductRowView`, `QuantityControlView`, and `AddToBagButtonView` each declare their own `ViewState` and `Action`. A translator copies the parent slice down. The parent maps child actions up. The processor is never passed down.

## Run it

```bash
cd Samples/FrescoUI
swift test
```

Open `Package.swift` in Xcode and use the `#Preview` on `MenuRootView`.

Host app: add this package, then `MenuRootView()` or copy `ExampleApp/MenuOrderingExampleApp.swift`.

## Package layout

```text
Sources/FrescoUI/                Processor, ReducerProtocol, WithProcessor
Sources/MenuServiceInterface/    Protocol + models
Sources/MenuUI/                  Screens, processors, MockMenuService
Tests/
ExampleApp/
```

## License

MIT. See `LICENSE`.
