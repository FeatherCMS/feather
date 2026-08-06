//
//  EventDispatchError.swift
//  app-kernel
//

public struct EventDispatchError: Error {

    public let eventType: String
    public let handlerID: String
    public let underlyingError: any Error

    public init(
        eventType: String,
        handlerID: String,
        underlyingError: any Error
    ) {
        self.eventType = eventType
        self.handlerID = handlerID
        self.underlyingError = underlyingError
    }
}
