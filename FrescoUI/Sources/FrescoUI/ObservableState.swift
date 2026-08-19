import SwiftUI

@propertyWrapper @MainActor
struct ObservableState<Value: AnyObject & Observable>: DynamicProperty {
    @StateObject private var container = ValueContainer<Value>()
    let makeValue: () -> Value

    init(wrappedValue: @autoclosure @escaping () -> Value) {
        makeValue = wrappedValue
    }

    var wrappedValue: Value {
        container.value ?? makeValue()
    }

    var projectedValue: Bindable<Value> {
        Bindable(wrappedValue)
    }

    nonisolated func update() {
        MainActor.assumeIsolated {
            if container.value == nil {
                container.value = makeValue()
            }
        }
    }
}

private final class ValueContainer<Value: Observable>: ObservableObject {
    var value: Value?
}
