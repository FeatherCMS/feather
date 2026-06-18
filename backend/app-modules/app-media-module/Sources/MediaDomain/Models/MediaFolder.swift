import Domain
import struct Foundation.Date

public struct MediaFolder: Model {
    public struct New: Sendable {
        public let id: String
        public let parentId: String?
        public let name: String
        public let path: String
        public let assetCount: Int
        public let totalSizeBytes: Int64
    }

    public let id: String
    public var parentId: String?
    public var name: String
    public var path: String
    public var assetCount: Int
    public var totalSizeBytes: Int64
    public let createdAt: Date
    public let updatedAt: Date
    public let deletedAt: Date?

    package init(
        id: String,
        parentId: String?,
        name: String,
        path: String,
        assetCount: Int,
        totalSizeBytes: Int64,
        createdAt: Date,
        updatedAt: Date,
        deletedAt: Date?
    ) {
        self.id = id
        self.parentId = parentId
        self.name = name
        self.path = path
        self.assetCount = assetCount
        self.totalSizeBytes = totalSizeBytes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
}

public extension MediaFolder {
    static func create(
        id: String,
        parentId: String?,
        name: String,
        path: String
    ) -> Self.New {
        .init(
            id: id,
            parentId: parentId,
            name: name,
            path: path,
            assetCount: 0,
            totalSizeBytes: 0
        )
    }
}
