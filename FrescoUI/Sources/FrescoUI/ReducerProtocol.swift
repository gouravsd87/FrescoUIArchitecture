/// Pure state transition. The only code that writes `ViewState`.
///
/// Reducers must not call services, start tasks, or perform I/O.
public protocol ReducerProtocol<ViewState, Action> {
    associatedtype ViewState
    associatedtype Action

    func update(_ viewState: inout ViewState, with action: Action)
}
