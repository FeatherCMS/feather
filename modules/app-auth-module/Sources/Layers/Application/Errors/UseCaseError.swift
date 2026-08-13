//
//  UseCaseError.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

//import FeatherError

public struct UseCaseError: Error {

    public enum Reason: String, CaseIterable, Sendable, Equatable, Hashable,
        Codable
    {
        case auth
        case validation
        case persistence
        case unknown
    }

    public var reason: Reason
    public var debugMessage: String
    public var message: String
    public var underlyingErrors: [Error]

    public init(
        reason: Reason,
        logMessage: String,
        userFriendlyMessage: String,
        underlyingErrors: [Error] = []
    ) {
        self.reason = reason
        self.debugMessage = logMessage
        self.message = userFriendlyMessage
        self.underlyingErrors = underlyingErrors
    }
}
