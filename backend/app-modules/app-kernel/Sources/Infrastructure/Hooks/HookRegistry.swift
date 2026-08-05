//
//  HookRegistry.swift
//  app-kernel
//

import Application

public struct HookRegistry<Context: Sendable>: Sendable {

    private let handlers: [ObjectIdentifier: [AnyHookHandler<Context>]]

    init(
        handlers: [ObjectIdentifier: [AnyHookHandler<Context>]]
    ) {
        self.handlers = handlers
    }

    public func dispatcher(
        context: Context
    ) -> ContextualHookDispatcher<Context> {
        .init(registry: self, context: context)
    }

    func dispatch<H: Hook>(
        _ hook: H,
        context: Context
    ) async throws {
        let key = ObjectIdentifier(H.self)
        for handler in handlers[key, default: []] {
            try await handler.invoke(hook, context)
        }
    }
}
