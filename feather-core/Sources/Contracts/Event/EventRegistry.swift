//
//  EventRegistry.swift
//  feather-core
//

public struct EventRegistry: EventPublisher {

    private var handlers: [ObjectIdentifier: [AnyEventHandler]] = [:]

    public init() {}

    public mutating func register<
        E: Event,
        Context: ExecutionContext
    >(
        event: E.Type,
        context: Context.Type,
        handler: @Sendable @escaping (E, Context) async throws -> E.Output
    ) {
        let key = ObjectIdentifier(event)
        handlers[key, default: []]
            .append(
                AnyEventHandler(
                    event: event,
                    handler: handler
                )
            )
    }

    @discardableResult
    public func trigger<E: Event>(
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
    public func trigger<E: Event>(
        event: E,
        using context: any ExecutionContext,
        options: EventTriggerOptions
    ) async throws -> [E.Output] {
        var results: [E.Output] = []

        for handler in handlers[ObjectIdentifier(E.self), default: []] {
            do {
                let result = try await handler.trigger(
                    event,
                    context
                )

                guard let result = result as? E.Output else {
                    throw EventError.invalidResultType(
                        eventType: String(reflecting: E.self),
                        expected: String(reflecting: E.Output.self),
                        actual: String(reflecting: type(of: result))
                    )
                }

                results.append(result)

                if options[.invocationPolicy] == .first {
                    break
                }
            }
            catch let error as EventError {
                if options[.contextPolicy] == .skipIncompatible,
                    case .invalidContextType = error
                {
                    continue
                }

                throw error
            }
            catch {
                throw error
            }
        }

        return results
    }
}
