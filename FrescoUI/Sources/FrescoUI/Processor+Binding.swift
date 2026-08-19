import SwiftUI

public extension Processor {
    /// Reads `ViewState` and turns writes into actions (the reducer is still the only writer).
    func makeBinding<T>(
        _ keyPath: KeyPath<ViewState, T>,
        action: @escaping (T) -> Action
    ) -> Binding<T> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.send(action($0)) }
        )
    }

    func makeBinding<T>(
        _ keyPath: KeyPath<ViewState, T>,
        action: @autoclosure @escaping () -> Action
    ) -> Binding<T> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { _ in self.send(action()) }
        )
    }

    func makeBinding<T>(_ keyPath: KeyPath<ViewState, T>) -> Binding<T> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { _ in }
        )
    }

    func makeDebouncedBinding<T: Sendable>(
        _ keyPath: KeyPath<ViewState, T>,
        action: @Sendable @escaping (T) -> Action,
        delay: Duration
    ) -> Binding<T> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.sendDebounced(action($0), delay: delay) }
        )
    }
}
