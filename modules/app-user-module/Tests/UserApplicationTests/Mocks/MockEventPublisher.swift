import FeatherContracts
import UserApplication

actor MockEventPublisher: EventPublisher {

    private(set) var triggerCallCount = 0
    private(set) var identityIDs: [String] = []

    @discardableResult
    func trigger<E: Event>(
        event: E,
        using context: any ExecutionContext
    ) async throws -> [E.Output] {
        try await trigger(
            event: event,
            using: context,
            options: EventTriggerOptions()
        )
    }

    @discardableResult
    func trigger<E: Event>(
        event: E,
        using context: any ExecutionContext,
        options: EventTriggerOptions
    ) async throws -> [E.Output] {
        triggerCallCount += 1
        if let event = event as? UserIdentityDidInsert {
            identityIDs.append(event.identityID)
        }
        return []
    }
}
