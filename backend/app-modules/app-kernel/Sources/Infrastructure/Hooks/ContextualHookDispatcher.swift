//
//  ContextualHookDispatcher.swift
//  app-kernel
//

import Application

public struct ContextualHookDispatcher<Context: Sendable>: HookDispatcher {

    private let registry: HookRegistry<Context>
    private let context: Context

    init(
        registry: HookRegistry<Context>,
        context: Context
    ) {
        self.registry = registry
        self.context = context
    }

    public func dispatch<H: Hook>(
        _ hook: H
    ) async throws {
        try await registry.dispatch(hook, context: context)
    }
}
