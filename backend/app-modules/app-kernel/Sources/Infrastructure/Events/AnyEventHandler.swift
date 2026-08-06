//
//  AnyEventHandler.swift
//  app-kernel
//

import Application

struct AnyEventHandler<Context: Sendable>: Sendable {

    let handlerID: String
    let invoke: @Sendable (any Event, Context) async throws -> Void

    init<E: Event>(
        event: E.Type,
        id: String,
        handler: @Sendable @escaping (E, Context) async throws -> Void
    ) {
        let eventType = String(reflecting: event)
        self.handlerID = id
        self.invoke = { value, context in
            guard let value = value as? E else {
                throw EventHandlerRegistryError.invalidEventType(
                    expected: eventType,
                    actual: String(reflecting: type(of: value))
                )
            }

            do {
                try await handler(value, context)
            }
            catch {
                throw EventDispatchError(
                    eventType: eventType,
                    handlerID: id,
                    underlyingError: error
                )
            }
        }
    }
}
