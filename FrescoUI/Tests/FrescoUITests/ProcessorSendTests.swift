import Testing
import FrescoUI

private struct CounterState: Equatable {
    var value = 0
    var didLoad = false
}

private enum CounterAction: Equatable, Sendable {
    case increment
    case load
    case loaded
}

private struct CounterReducer: ReducerProtocol {
    func update(_ viewState: inout CounterState, with action: CounterAction) {
        switch action {
        case .increment:
            viewState.value += 1
        case .load:
            break
        case .loaded:
            viewState.didLoad = true
        }
    }
}

@MainActor
private final class CounterProcessor: Processor<CounterState, CounterAction> {
    init() {
        super.init(state: CounterState(), reducer: CounterReducer())
    }

    override func process(_ action: CounterAction) async -> CounterAction? {
        switch action {
        case .load:
            return .loaded
        case .increment, .loaded:
            return nil
        }
    }
}

@MainActor
struct ProcessorSendTests {
    @Test func syncActionUpdatesStateImmediately() {
        let processor = CounterProcessor()
        processor.send(.increment)
        #expect(processor.state.value == 1)
        #expect(processor.state.didLoad == false)
    }

    @Test func asyncProcessReturnsFollowUpAction() async {
        let processor = CounterProcessor()
        await processor.sendAsync(.load)
        #expect(processor.state.didLoad == true)
    }
}
