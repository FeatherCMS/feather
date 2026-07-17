import Domain
import struct Foundation.Date

public struct Credential: Model {

    public enum Error: DomainError {
        case invalidAccountID
        case emailTooShort
        case emailTooLong
        case passwordHashTooShort
        case passwordHashTooLong
    }

    public struct New: Sendable {
        public let id: String
        public let accountID: String
        public let email: String
        public let passwordHash: String
    }

    public let id: String
    public let accountID: String
    public var email: String
    public var passwordHash: String
    public let createdAt: Date
    public var updatedAt: Date

    package init(
        id: String,
        accountID: String,
        email: String,
        passwordHash: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.accountID = accountID
        self.email = email
        self.passwordHash = passwordHash
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public extension Credential {

    private static func validate(
        accountID: String
    ) throws(Self.Error) {
        guard !accountID.isEmpty else {
            throw .invalidAccountID
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

    static func create(
        id: String,
        accountID: String,
        email: String,
        passwordHash: String
    ) throws(Self.Error) -> Self.New {
        try validate(accountID: accountID)
        try validate(email: email)
        try validate(passwordHash: passwordHash)

        return .init(
            id: id,
            accountID: accountID,
            email: email,
            passwordHash: passwordHash
        )
    }

    mutating func update(
        email: String? = nil,
        passwordHash: String? = nil
    ) throws(Self.Error) {
        let newEmail = email ?? self.email
        let newPasswordHash = passwordHash ?? self.passwordHash

        try Self.validate(email: newEmail)
        try Self.validate(passwordHash: newPasswordHash)

        self.email = newEmail
        self.passwordHash = newPasswordHash
        self.updatedAt = .init()
    }
}
