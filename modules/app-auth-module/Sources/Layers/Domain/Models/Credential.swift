public import FeatherDomain

public import struct Foundation.Date

public struct Credential: Model {

    public enum Error: DomainError {
        case authEmailIdTooShort
        case authEmailIdTooLong
        case passwordHashTooShort
        case passwordHashTooLong
    }

    public struct New: Sendable {
        public let authEmailId: String
        public let passwordHash: String
    }

    public let id: String
    public var authEmailId: String
    public var passwordHash: String
    public let createdAt: Date
    public var updatedAt: Date

    package init(
        id: String,
        authEmailId: String,
        passwordHash: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.authEmailId = authEmailId
        self.passwordHash = passwordHash
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Credential {

    private static func validate(
        authEmailId: String
    ) throws(Self.Error) {
        guard authEmailId.count > 3 else {
            throw .authEmailIdTooShort
        }
        guard authEmailId.count < 255 else {
            throw .authEmailIdTooLong
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
        authEmailId: String,
        passwordHash: String,
    ) throws(Self.Error) -> Self.New {
        try validate(authEmailId: authEmailId)
        try validate(passwordHash: passwordHash)

        return .init(
            authEmailId: authEmailId,
            passwordHash: passwordHash,
        )
    }

    public mutating func update(
        authEmailId: String? = nil,
        passwordHash: String? = nil,
    ) throws(Self.Error) {
        let newPasswordHash = passwordHash ?? self.passwordHash

        if let authEmailId {
            try Self.validate(authEmailId: authEmailId)
            self.authEmailId = authEmailId
        }
        try Self.validate(passwordHash: newPasswordHash)

        self.passwordHash = newPasswordHash
        self.updatedAt = .init()
    }
}
