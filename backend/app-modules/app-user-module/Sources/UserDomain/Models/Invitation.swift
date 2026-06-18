import Domain
import struct Foundation.Date

public struct Invitation: Model {

    public enum Error: DomainError {
        case emailTooShort
        case emailTooLong
        case tokenTooShort
        case tokenTooLong

        case alreadyUsed
        case expired
    }

    public static let lifetime: Double = 86_400

    public struct New: Sendable {
        public let id: String
        public let email: String
        public let token: String
        public let expiresAtInterval: Double
    }

    public let id: String
    public let email: String
    public let token: String
    // TODO: isUsed?
    public let expiresAt: Date
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        email: String,
        token: String,
        expiresAt: Date,
        createdAt: Date,
        updatedAt: Date,
    ) {
        self.id = id
        self.email = email
        self.token = token
        self.expiresAt = expiresAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public extension Invitation {

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
        token: String
    ) throws(Self.Error) -> Self.New {
        try validate(email: email)
        try validate(token: token)

        return .init(
            id: id,
            email: email,
            token: token,
            expiresAtInterval: lifetime
        )
    }

    mutating func update(
        email: String?
    ) throws(Self.Error) {
        guard let email else {
            return
        }

        try Self.validate(email: email)
        self = .init(
            id: id,
            email: email,
            token: token,
            expiresAt: expiresAt,
            createdAt: createdAt,
            updatedAt: .init()
        )
    }

    mutating func consume(
        now: Date = .init()
    ) throws(Self.Error) {
        //        guard !self.isUsed else {
        //            throw .alreadyUsed
        //        }
        guard expiresAt > now else {
            throw .expired
        }
        //        self.isUsed = true
    }
}
