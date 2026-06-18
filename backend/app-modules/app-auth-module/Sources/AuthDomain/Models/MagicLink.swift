import Domain
import struct Foundation.Date

public struct MagicLink: Model {

    public enum Error: DomainError {
        case emailTooShort
        case emailTooLong
        case tokenTooShort
        case tokenTooLong

        case alreadyUsed
        case expired
    }

    static let lifetime: Double = 3_600

    // MARK: -

    public struct New: Sendable {
        public let id: String
        public let email: String
        public let token: String
        public let expiresAtInterval: Double
        public let isPersistent: Bool
    }

    public let id: String
    public let email: String
    public let token: String
    public let expiresAt: Date
    public let isPersistent: Bool
    public var isUsed: Bool
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        email: String,
        token: String,
        expiresAt: Date,
        isPersistent: Bool,
        isUsed: Bool,
        createdAt: Date,
        updatedAt: Date,
    ) {
        self.id = id
        self.email = email
        self.token = token
        self.expiresAt = expiresAt
        self.isPersistent = isPersistent
        self.isUsed = isUsed
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public extension MagicLink {

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
        token: String
    ) throws(Self.Error) {
        guard token.count > 8 else {
            throw .tokenTooShort
        }
        guard token.count < 255 else {
            throw .tokenTooLong
        }
    }

    static func create(
        id: String,
        email: String,
        token: String,
        isPersistent: Bool
    ) throws(Self.Error) -> Self.New {
        try validate(email: email)
        try validate(token: token)

        return .init(
            id: id,
            email: email,
            token: token,
            expiresAtInterval: lifetime,
            isPersistent: isPersistent
        )
    }

    mutating func consume(
        now: Date = .init()
    ) throws(Self.Error) {
        guard !self.isUsed else {
            throw .alreadyUsed
        }
        guard expiresAt > now else {
            throw .expired
        }
        self.isUsed = true
    }
}
