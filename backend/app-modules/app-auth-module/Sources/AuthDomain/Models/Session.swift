import Domain
import struct Foundation.Date

public struct Session: Model {

    public enum Error: DomainError {
        case idTooShort
        case idTooLong

        case tokenTooShort
        case tokenTooLong

        case accountIdTooShort
        case accountIdTooLong
    }

    public enum Lifetimes {
        public static let regular: Double = 86_400  // 1 day
        public static let persistent: Double = 604_800  // 7 days
    }

    public struct New: Sendable {
        public let id: String
        public let token: String
        public let accountId: String
        public let expiresAtInterval: Double
        public let isPersistent: Bool
    }

    public let id: String
    public let token: String
    public let accountId: String
    public var expiresAt: Double
    public let isPersistent: Bool
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        token: String,
        accountId: String,
        expiresAt: Double,
        isPersistent: Bool,
        createdAt: Date,
        updatedAt: Date,
    ) {
        self.id = id
        self.token = token
        self.accountId = accountId
        self.expiresAt = expiresAt
        self.isPersistent = isPersistent
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public extension Session {

    private static func validate(
        id: String
    ) throws(Self.Error) {
        guard id.count > 3 else {
            throw .idTooShort
        }
        guard id.count < 255 else {
            throw .idTooLong
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

    private static func validate(
        accountId: String
    ) throws(Self.Error) {
        guard accountId.count > 3 else {
            throw .accountIdTooShort
        }
        guard accountId.count < 255 else {
            throw .accountIdTooLong
        }
    }

    static func create(
        id: String,
        token: String,
        accountId: String,
        expiresAtInterval: Double,
        isPersistent: Bool
    ) throws(Self.Error) -> Self.New {
        try validate(id: id)
        try validate(token: token)
        try validate(accountId: accountId)

        return .init(
            id: id,
            token: token,
            accountId: accountId,
            expiresAtInterval: expiresAtInterval,
            isPersistent: isPersistent
        )
    }

    //    mutating func update(
    //        name: String? = nil,
    //        notes: String? = nil
    //    ) throws(Self.Error) {
    //        let newName = name ?? self.name
    //        let newNotes = notes ?? self.notes
    //
    //        try Self.validate(name: newName)
    //        try Self.validate(notes: newNotes)
    //
    //        self.name = newName
    //        self.notes = newNotes
    //    }
}
