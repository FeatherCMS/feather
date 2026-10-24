//
//  QueryError.swift
//  feather-core
//

public struct QueryError: Error {

    public enum Reason: Sendable, Equatable, Hashable, Codable {
        case notFound
        case database
        case unknown
    }

    public let reason: Reason
    public let debugMessage: String
    public let message: String
    public let underlyingErrors: [any Error]

    public init(
        reason: Reason,
        logMessage: String,
        userFriendlyMessage: String,
        underlyingErrors: [any Error] = []
    ) {
        self.reason = reason
        self.debugMessage = logMessage
        self.message = userFriendlyMessage
        self.underlyingErrors = underlyingErrors
    }
}

extension QueryError {

    public static var notFound: Self {
        .init(
            reason: .notFound,
            logMessage: "Query result not found",
            userFriendlyMessage: "The requested result was not found."
        )
    }
}
