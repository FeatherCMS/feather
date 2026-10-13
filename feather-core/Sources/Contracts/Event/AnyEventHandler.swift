//
//  AnyEventHandler.swift
//  feather-core
//

struct AnyEventHandler: Sendable {

    let trigger:
        @Sendable (
            any Event,
            any ExecutionContext
        ) async throws -> any Sendable

    init<
        E: Event,
        Context: ExecutionContext
    >(
        event: E.Type,
        handler:
            @Sendable @escaping (
                E,
                Context
            ) async throws -> E.Output
    ) {
        let eventType = String(reflecting: event)
        let contextType = String(reflecting: Context.self)
        self.trigger = { value, context in
            guard let value = value as? E else {
                throw EventError.invalidEventType(
                    expected: eventType,
                    actual: String(reflecting: type(of: value))
                )
            }
            guard let context = context as? Context else {
                throw EventError.invalidContextType(
                    expected: contextType,
                    actual: String(reflecting: type(of: context))
                )
            }

            do {
                return try await handler(value, context)
            }
            catch {
                throw EventError.failure(
                    eventType: eventType,
                    underlyingError: error
                )
            }
        }
    }
}
