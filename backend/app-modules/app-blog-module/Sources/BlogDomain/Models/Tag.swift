import Domain
import struct Foundation.Date

public struct Tag: Model {

    public enum Error: DomainError {
        case titleTooShort
        case titleTooLong
        case excerptTooLong
        case contentTooLong
    }

    public struct New: Sendable {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
    }

    public let id: String
    public var title: String
    public var excerpt: String
    public var content: String
    public var imageAssetId: String?
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        title: String,
        excerpt: String,
        content: String,
        imageAssetId: String?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.title = title
        self.excerpt = excerpt
        self.content = content
        self.imageAssetId = imageAssetId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public extension Tag {

    private static func validate(
        title: String
    ) throws(Self.Error) {
        guard !title.isEmpty else {
            throw .titleTooShort
        }
        guard title.count < 255 else {
            throw .titleTooLong
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
        title: String,
        excerpt: String,
        content: String,
        imageAssetId: String? = nil
    ) throws(Self.Error) -> Self.New {
        try validate(title: title)
        try validate(excerpt: excerpt)
        try validate(content: content)

        return .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId
        )
    }

    mutating func update(
        title: String? = nil,
        excerpt: String? = nil,
        content: String? = nil,
        imageAssetId: String?? = nil
    ) throws(Self.Error) {
        let newTitle = title ?? self.title
        let newExcerpt = excerpt ?? self.excerpt
        let newContent = content ?? self.content

        try Self.validate(title: newTitle)
        try Self.validate(excerpt: newExcerpt)
        try Self.validate(content: newContent)

        self.title = newTitle
        self.excerpt = newExcerpt
        self.content = newContent
        self.imageAssetId = imageAssetId ?? self.imageAssetId
    }
}
