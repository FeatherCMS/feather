import FeatherDomain

import struct Foundation.Date

public struct Credential: Model {

    public enum Error: DomainError {
        case invalidUserId
        case emailTooShort
        case emailTooLong
        case passwordHashTooShort
        case passwordHashTooLong
    }

    public struct New: Sendable {
        public let userId: String
        public let email: String
        public let passwordHash: String
    }

    public let id: String
    public var userId: String
    public var email: String
    public var passwordHash: String
    public let createdAt: Date
    public var updatedAt: Date

    package init(
        id: String,
        userId: String,
        email: String,
        passwordHash: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.userId = userId
        self.email = email
        self.passwordHash = passwordHash
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Credential {

    private static func validate(
        userId: String
    ) throws(Self.Error) {
        guard !userId.isEmpty else {
            throw .invalidUserId
        }
    }

    private static func validate(
        email: String
    ) throws(Self.Error) {
        guard email.count > 3 else {
            throw .emailTooShort
        }
        guard email.count < 255 else {
            throw .emailTooLong
        }
    }

    private static func validate(
        passwordHash: String
    ) throws(Self.Error) {
        guard passwordHash.count > 8 else {
            throw .passwordHashTooShort
        }
        guard passwordHash.count < 255 else {
            throw .passwordHashTooLong
        }
    }

    public static func create(
        userId: String,
        email: String,
        passwordHash: String,
    ) throws(Self.Error) -> Self.New {
        try validate(userId: userId)
        try validate(email: email)
        try validate(passwordHash: passwordHash)

        return .init(
            userId: userId,
            email: email,
            passwordHash: passwordHash,
        )
    }

    public mutating func update(
        userId: String? = nil,
        email: String? = nil,
        passwordHash: String? = nil,
    ) throws(Self.Error) {
        let newEmail = email ?? self.email
        let newPasswordHash = passwordHash ?? self.passwordHash

        if let userId {
            try Self.validate(userId: userId)
            self.userId = userId
        }
        try Self.validate(email: newEmail)
        try Self.validate(passwordHash: newPasswordHash)

        self.email = newEmail
        self.passwordHash = newPasswordHash
        self.updatedAt = .init()
    }
}
