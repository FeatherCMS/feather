import FeatherContracts

actor MockEventPublisher: EventPublisher {
    @discardableResult
    func trigger<E: Event>(
        event: E,
        using context: any ExecutionContext
    ) async throws -> [E.Output] { [] }

    @discardableResult
    func trigger<E: Event>(
        event: E,
        using context: any ExecutionContext,
        options: EventTriggerOptions
    ) async throws -> [E.Output] { [] }
}
