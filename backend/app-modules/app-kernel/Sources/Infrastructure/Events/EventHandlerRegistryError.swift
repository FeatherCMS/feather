//
//  EventHandlerRegistryError.swift
//  app-kernel
//

public enum EventHandlerRegistryError: Error, Equatable, Sendable {
    case duplicateHandler(eventType: String, handlerID: String)
    case missingRequiredHandler(eventType: String, handlerID: String)
    case invalidEventType(expected: String, actual: String)
}
