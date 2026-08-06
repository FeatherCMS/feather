//
//  ContextualEventDispatcher.swift
//  app-kernel
//

import Application

public struct ContextualEventDispatcher<Context: Sendable>: EventDispatcher {

    private let registry: EventHandlerRegistry<Context>
    private let context: Context

    init(
        registry: EventHandlerRegistry<Context>,
        context: Context
    ) {
        self.registry = registry
        self.context = context
    }

    public func dispatch<E: Event>(
        _ event: E
    ) async throws {
        try await registry.dispatch(event, context: context)
    }
}
