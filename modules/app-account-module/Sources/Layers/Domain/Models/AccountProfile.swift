import FeatherDomain
import Foundation

public struct AccountProfile: Model {

    public enum Error: DomainError {
        case invalidUserId
        case firstNameTooLong
        case lastNameTooLong
    }

    public struct New: Sendable {
        public let userId: String
        public let firstName: String?
        public let lastName: String?
        public let profileImageAssetId: String?
    }

    public static let defaultFirstName: String? = nil
    public static let defaultLastName: String? = nil
    public static let maximumNameLength = 255

    public let userId: String
    public var firstName: String?
    public var lastName: String?
    public var profileImageAssetId: String?
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        userId: String,
        firstName: String?,
        lastName: String?,
        profileImageAssetId: String?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageAssetId = profileImageAssetId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension AccountProfile {

    private static func validate(userId: String) throws(Self.Error) {
        guard !userId.isEmpty else { throw .invalidUserId }
    }

    private static func validate(
        name: String?,
        error: Self.Error
    ) throws(Self.Error) {
        guard name?.count ?? 0 <= maximumNameLength else { throw error }
    }

    public static func create(
        userId: String,
        firstName: String? = Self.defaultFirstName,
        lastName: String? = Self.defaultLastName,
        profileImageAssetId: String? = nil
    ) throws(Self.Error) -> Self.New {
        try validate(userId: userId)
        try validate(name: firstName, error: .firstNameTooLong)
        try validate(name: lastName, error: .lastNameTooLong)
        return .init(
            userId: userId,
            firstName: firstName,
            lastName: lastName,
            profileImageAssetId: profileImageAssetId
        )
    }

    public mutating func update(
        firstName: String?,
        lastName: String?,
        profileImageAssetId: String?
    ) throws(Self.Error) {
        try Self.validate(userId: userId)
        try Self.validate(name: firstName, error: .firstNameTooLong)
        try Self.validate(name: lastName, error: .lastNameTooLong)
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageAssetId = profileImageAssetId
    }
}
