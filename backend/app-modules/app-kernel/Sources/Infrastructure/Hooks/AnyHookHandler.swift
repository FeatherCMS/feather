//
//  AnyHookHandler.swift
//  app-kernel
//

import Application

struct AnyHookHandler<Context: Sendable>: Sendable {

    let handlerID: String
    let invoke: @Sendable (any Hook, Context) async throws -> Void

    init<H: Hook>(
        hook: H.Type,
        id: String,
        handler: @Sendable @escaping (H, Context) async throws -> Void
    ) {
        let hookType = String(reflecting: hook)
        self.handlerID = id
        self.invoke = { value, context in
            guard let value = value as? H else {
                throw HookRegistryError.invalidHookType(
                    expected: hookType,
                    actual: String(reflecting: type(of: value))
                )
            }

            do {
                try await handler(value, context)
            }
            catch {
                throw HookDispatchError(
                    hookType: hookType,
                    handlerID: id,
                    underlyingError: error
                )
            }
        }
    }
}
