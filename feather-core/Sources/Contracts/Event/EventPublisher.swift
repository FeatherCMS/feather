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
