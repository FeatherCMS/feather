import FeatherModuleKit
import UserApplication
import UserModule

actor MockEventPublisher: EventPublisher {

    private(set) var triggerCallCount = 0
    private(set) var identityIDs: [String] = []

    @discardableResult
    func trigger<E: FeatherModuleKit.Event>(
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
    func trigger<E: FeatherModuleKit.Event>(
        event: E,
        using context: any ExecutionContext,
        options: EventTriggerOptions
    ) async throws -> [E.Output] {
        triggerCallCount += 1
        if let event = event as? Identity.Event.DidInsert {
            identityIDs.append(event.identityID)
        }
        return []
    }
}
