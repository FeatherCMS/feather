import Domain
import struct Foundation.Date

public struct Author: Model {

    public enum Error: DomainError {
        case nameTooShort
        case nameTooLong
        case excerptTooLong
        case contentTooLong
    }

    public struct New: Sendable {
        public let id: String
        public let name: String
        public let excerpt: String
        public let content: String
        public let profileImageAssetId: String?
    }

    public let id: String
    public var name: String
    public var excerpt: String
    public var content: String
    public var profileImageAssetId: String?
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        name: String,
        excerpt: String,
        content: String,
        profileImageAssetId: String?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.excerpt = excerpt
        self.content = content
        self.profileImageAssetId = profileImageAssetId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public extension Author {

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

    private static func validate(
        excerpt: String
    ) throws(Self.Error) {
        guard excerpt.count < 4_000 else {
            throw .excerptTooLong
        }
    }

    private static func validate(
        content: String
    ) throws(Self.Error) {
        guard content.count < 200_000 else {
            throw .contentTooLong
        }
    }

    static func create(
        id: String,
        name: String,
        excerpt: String,
        content: String,
        profileImageAssetId: String? = nil
    ) throws(Self.Error) -> Self.New {
        try validate(name: name)
        try validate(excerpt: excerpt)
        try validate(content: content)

        return .init(
            id: id,
            name: name,
            excerpt: excerpt,
            content: content,
            profileImageAssetId: profileImageAssetId
        )
    }

    mutating func update(
        name: String? = nil,
        excerpt: String? = nil,
        content: String? = nil,
        profileImageAssetId: String?? = nil
    ) throws(Self.Error) {
        let newName = name ?? self.name
        let newExcerpt = excerpt ?? self.excerpt
        let newContent = content ?? self.content
        let newProfileImageAssetId =
            profileImageAssetId ?? self.profileImageAssetId

        try Self.validate(name: newName)
        try Self.validate(excerpt: newExcerpt)
        try Self.validate(content: newContent)

        self.name = newName
        self.excerpt = newExcerpt
        self.content = newContent
        self.profileImageAssetId = newProfileImageAssetId
    }
}
