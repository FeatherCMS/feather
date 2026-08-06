//
//  EventHandlerRegistryBuilder.swift
//  app-kernel
//

import Application

public struct EventHandlerRegistryBuilder<Context: Sendable> {

    private var handlers: [ObjectIdentifier: [AnyEventHandler<Context>]] = [:]

    public init() {}

    public mutating func register<E: Event>(
        _ event: E.Type,
        id: String,
        handler: @Sendable @escaping (E, Context) async throws -> Void
    ) throws {
        let key = ObjectIdentifier(event)
        let eventType = String(reflecting: event)

        guard
            handlers[key]?
                .contains(where: {
                    $0.handlerID == id
                }) != true
        else {
            throw EventHandlerRegistryError.duplicateHandler(
                eventType: eventType,
                handlerID: id
            )
        }

        handlers[key, default: []]
            .append(
                AnyEventHandler(
                    event: event,
                    id: id,
                    handler: handler
                )
            )
    }

    public func contains<E: Event>(
        _ event: E.Type,
        id: String
    ) -> Bool {
        handlers[ObjectIdentifier(event)]?
            .contains {
                $0.handlerID == id
            } == true
    }

    public func require<E: Event>(
        _ event: E.Type,
        id: String
    ) throws {
        guard contains(event, id: id) else {
            throw EventHandlerRegistryError.missingRequiredHandler(
                eventType: String(reflecting: event),
                handlerID: id
            )
        }
    }

    public func build() -> EventHandlerRegistry<Context> {
        EventHandlerRegistry(handlers: handlers)
    }
}
