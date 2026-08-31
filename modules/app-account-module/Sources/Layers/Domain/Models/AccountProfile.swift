import FeatherDomain
import Foundation

public struct AccountProfile: Model {

    public enum Error: DomainError {
        case invalidUserId
        case firstNameTooLong
        case lastNameTooLong
        case imageURLTooLong
    }

    public struct New: Sendable {
        public let userId: String
        public let firstName: String?
        public let lastName: String?
        public let imageURL: String?
    }

    public static let defaultFirstName: String? = nil
    public static let defaultLastName: String? = nil
    public static let maximumNameLength = 255
    public static let maximumImageURLLength = 2048

    public let userId: String
    public var firstName: String?
    public var lastName: String?
    public var imageURL: String?
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        userId: String,
        firstName: String?,
        lastName: String?,
        imageURL: String?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.imageURL = imageURL
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

    private static func validate(imageURL: String?) throws(Self.Error) {
        guard imageURL?.count ?? 0 <= maximumImageURLLength else {
            throw .imageURLTooLong
        }
    }

    public static func create(
        userId: String,
        firstName: String? = Self.defaultFirstName,
        lastName: String? = Self.defaultLastName,
        imageURL: String? = nil
    ) throws(Self.Error) -> Self.New {
        try validate(userId: userId)
        try validate(name: firstName, error: .firstNameTooLong)
        try validate(name: lastName, error: .lastNameTooLong)
        try validate(imageURL: imageURL)
        return .init(
            userId: userId,
            firstName: firstName,
            lastName: lastName,
            imageURL: imageURL
        )
    }

    public mutating func update(
        firstName: String?,
        lastName: String?,
        imageURL: String?
    ) throws(Self.Error) {
        try Self.validate(userId: userId)
        try Self.validate(name: firstName, error: .firstNameTooLong)
        try Self.validate(name: lastName, error: .lastNameTooLong)
        try Self.validate(imageURL: imageURL)
        self.firstName = firstName
        self.lastName = lastName
        self.imageURL = imageURL
    }
}
