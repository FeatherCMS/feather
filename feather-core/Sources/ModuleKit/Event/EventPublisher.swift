//
//  EventPublisher.swift
//  feather-core
//

public protocol EventPublisher: Sendable {

    @discardableResult
    func trigger<E: Event>(
        event: E,
        using context: any ExecutionContext
    ) async throws -> [E.Output]

    @discardableResult
    func trigger<E: Event>(
        event: E,
        using context: any ExecutionContext,
        options: EventTriggerOptions
    ) async throws -> [E.Output]
}

extension EventPublisher {

    @discardableResult
    public func trigger<E: Event>(
        event: E
    ) async throws -> [E.Output] {
        try await trigger(
            event: event,
            using: DefaultEventContext()
        )
    }
}
