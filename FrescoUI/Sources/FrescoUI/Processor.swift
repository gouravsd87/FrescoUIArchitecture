import Foundation
import Observation
import SwiftUI

/// Owns `ViewState`, runs the reducer synchronously, then optionally performs async work.
///
/// Views never hold a processor. They receive `state` and an `actionHandler`.
/// The processor never assigns `state` properties directly — it always `send`s.
@Observable @dynamicMemberLookup @MainActor open class Processor<ViewState, Action: Sendable>: ObservableObject {
    public private(set) var state: ViewState
    private var reducer: any ReducerProtocol<ViewState, Action>
    private var debounceTask: Task<Void, Error>?

    /// Applies the reducer immediately, then runs `process` on a new task.
    /// If `process` returns a follow-up action, that action is `send` again.
    public final func send(_ action: Action) {
        apply(action)

        Task {
            if let nextAction = await process(action) {
                send(nextAction)
            }
        }
    }

    /// Same loop as `send`, but awaits async work. Prefer this in tests.
    public final func sendAsync(_ action: Action) async {
        apply(action)

        if let nextAction = await process(action) {
            send(nextAction)
        }
    }

    /// Side effects live here: services, navigation, streams.
    /// Return an action to chain, or `send` additional actions, then return `nil`.
    open func process(_ action: Action) async -> Action? {
        nil
    }

    final func apply(_ action: Action) {
        reducer.update(&state, with: action)
    }

    public init(state: ViewState, reducer: some ReducerProtocol<ViewState, Action>) {
        self.state = state
        self.reducer = reducer
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<ViewState, T>) -> T {
        state[keyPath: keyPath]
    }

    /// Runs `process` only after calls settle for `delay`. The reducer still applies immediately.
    public final func sendDebounced(_ action: Action, delay: Duration) {
        apply(action)

        debounceTask?.cancel()
        debounceTask = Task {
            try await Task.sleep(for: delay)
            guard !Task.isCancelled else { return }
            if let nextAction = await process(action) {
                send(nextAction)
            }
        }
    }
}

/// Keeps a processor (or other `@Observable` object) alive for a SwiftUI subtree.
public struct WithProcessor<Value: AnyObject & Observable, Content: View>: View {
    @ObservableState var state: Value
    private let content: (Value) -> Content

    public init(_ makeValue: @escaping () -> Value, @ViewBuilder content: @escaping (Value) -> Content) {
        _state = ObservableState(wrappedValue: makeValue())
        self.content = content
    }

    public var body: some View {
        content(state)
    }
}
