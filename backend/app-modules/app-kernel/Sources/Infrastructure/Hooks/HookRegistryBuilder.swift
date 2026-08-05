//
//  HookRegistryBuilder.swift
//  app-kernel
//

import Application

public struct HookRegistryBuilder<Context: Sendable> {

    private var handlers: [ObjectIdentifier: [AnyHookHandler<Context>]] = [:]

    public init() {}

    public mutating func register<H: Hook>(
        _ hook: H.Type,
        id: String,
        handler: @Sendable @escaping (H, Context) async throws -> Void
    ) throws {
        let key = ObjectIdentifier(hook)
        let hookType = String(reflecting: hook)

        guard
            handlers[key]?
                .contains(where: {
                    $0.handlerID == id
                }) != true
        else {
            throw HookRegistryError.duplicateHandler(
                hookType: hookType,
                handlerID: id
            )
        }

        handlers[key, default: []]
            .append(
                AnyHookHandler(
                    hook: hook,
                    id: id,
                    handler: handler
                )
            )
    }

    public func contains<H: Hook>(
        _ hook: H.Type,
        id: String
    ) -> Bool {
        handlers[ObjectIdentifier(hook)]?
            .contains {
                $0.handlerID == id
            } == true
    }

    public func require<H: Hook>(
        _ hook: H.Type,
        id: String
    ) throws {
        guard contains(hook, id: id) else {
            throw HookRegistryError.missingRequiredHandler(
                hookType: String(reflecting: hook),
                handlerID: id
            )
        }
    }

    public func build() -> HookRegistry<Context> {
        HookRegistry(handlers: handlers)
    }
}
