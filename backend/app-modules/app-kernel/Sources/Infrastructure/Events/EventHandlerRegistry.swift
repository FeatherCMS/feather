//
//  EventHandlerRegistry.swift
//  app-kernel
//

import Application

public struct EventHandlerRegistry<Context: Sendable>: Sendable {

    private let handlers: [ObjectIdentifier: [AnyEventHandler<Context>]]

    init(
        handlers: [ObjectIdentifier: [AnyEventHandler<Context>]]
    ) {
        self.handlers = handlers
    }

    public func dispatcher(
        context: Context
    ) -> ContextualEventDispatcher<Context> {
        .init(registry: self, context: context)
    }

    func dispatch<E: Event>(
        _ event: E,
        context: Context
    ) async throws {
        let key = ObjectIdentifier(E.self)
        for handler in handlers[key, default: []] {
            try await handler.invoke(event, context)
        }
    }
}
