public import FeatherDomain

public import struct Foundation.Date

public struct MediaAssetNodeFolder: Model {
    public struct New: Sendable {
        public let parentId: String?
        public let name: String
        public let slug: String
        public let slugPath: String
        public let assetCount: Int
        public let totalSizeBytes: Int64
    }

    public let id: String
    public var parentId: String?
    public var name: String
    public var slug: String
    public var slugPath: String
    public var assetCount: Int
    public var totalSizeBytes: Int64
    public let createdAt: Date
    public let updatedAt: Date
    public let deletedAt: Date?

    package init(
        id: String,
        parentId: String?,
        name: String,
        slug: String,
        slugPath: String,
        assetCount: Int,
        totalSizeBytes: Int64,
        createdAt: Date,
        updatedAt: Date,
        deletedAt: Date?
    ) {
        self.id = id
        self.parentId = parentId
        self.name = name
        self.slug = slug
        self.slugPath = slugPath
        self.assetCount = assetCount
        self.totalSizeBytes = totalSizeBytes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
}

extension MediaAssetNodeFolder {
    public static func create(
        parentId: String?,
        name: String,
        slug: String,
        slugPath: String
    ) -> Self.New {
        .init(
            parentId: parentId,
            name: name,
            slug: slug,
            slugPath: slugPath,
            assetCount: 0,
            totalSizeBytes: 0
        )
    }
}
