//
//  EventError.swift
//  feather-core
//

public enum EventError: Error {
    case failure(
        eventType: String,
        underlyingError: any Error
    )

    case invalidEventType(
        expected: String,
        actual: String
    )

    case invalidContextType(
        expected: String,
        actual: String
    )

    case invalidResultType(
        eventType: String,
        expected: String,
        actual: String
    )
}
