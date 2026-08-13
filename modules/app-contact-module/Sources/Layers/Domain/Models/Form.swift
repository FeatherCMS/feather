import FeatherDomain

import struct Foundation.Date

public struct Form: Model {

    public enum Error: DomainError {
        case nameTooShort
        case nameTooLong
    }

    public struct New: Sendable {
        public let name: String
        public let successMessage: String
        public let failureMessage: String
        public let redirectUrl: String?
    }

    public let id: String
    public var name: String
    public var successMessage: String
    public var failureMessage: String
    public var redirectUrl: String?
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.successMessage = successMessage
        self.failureMessage = failureMessage
        self.redirectUrl = redirectUrl
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Form {

    private static func validate(
        name: String
    ) throws(Self.Error) {
        guard !name.isEmpty else {
            throw .nameTooShort
        }
        guard name.count < 255 else {
            throw .nameTooLong
        }
    }

    public static func create(
        name: String,
        successMessage: String = "",
        failureMessage: String = "",
        redirectUrl: String? = nil
    ) throws(Self.Error) -> Self.New {
        try validate(name: name)
        return .init(
            name: name,
            successMessage: successMessage,
            failureMessage: failureMessage,
            redirectUrl: redirectUrl
        )
    }

    public mutating func update(
        name: String? = nil,
        successMessage: String? = nil,
        failureMessage: String? = nil,
        redirectUrl: String?? = nil
    ) throws(Self.Error) {
        let newName = name ?? self.name
        try Self.validate(name: newName)
        self.name = newName
        if let successMessage { self.successMessage = successMessage }
        if let failureMessage { self.failureMessage = failureMessage }
        if let redirectUrl { self.redirectUrl = redirectUrl }
    }
}
