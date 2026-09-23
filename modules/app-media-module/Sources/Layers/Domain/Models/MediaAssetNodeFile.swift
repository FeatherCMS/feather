public import FeatherDomain

public import struct Foundation.Date

public struct MediaAssetNodeFile: Model {

    public enum Status: String, Sendable {
        case uploaded
        case processing
        case ready
    }

    public struct New: Sendable {
        public let folderId: String?
        public let name: String
        public let slug: String
        public let slugPath: String
        public let `extension`: String
        public let contentType: String
        public let sizeBytes: Int64
        public let status: Status
        public let title: String?
        public let altText: String?
    }

    public let id: String
    public var folderId: String?
    public var name: String
    public var slug: String
    public var slugPath: String
    public let storageObjectId: String
    public let objectKey: String
    public let `extension`: String
    public let contentType: String
    public let sizeBytes: Int64
    public var status: Status
    public var title: String?
    public var altText: String?
    public let createdAt: Date
    public let updatedAt: Date
    public let deletedAt: Date?

    package init(
        id: String,
        folderId: String?,
        name: String,
        slug: String,
        slugPath: String,
        storageObjectId: String,
        objectKey: String,
        `extension`: String,
        contentType: String,
        sizeBytes: Int64,
        status: Status,
        title: String?,
        altText: String?,
        createdAt: Date,
        updatedAt: Date,
        deletedAt: Date?
    ) {
        self.id = id
        self.folderId = folderId
        self.name = name
        self.slug = slug
        self.slugPath = slugPath
        self.storageObjectId = storageObjectId
        self.objectKey = objectKey
        self.extension = `extension`
        self.contentType = contentType
        self.sizeBytes = sizeBytes
        self.status = status
        self.title = title
        self.altText = altText
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
}

extension MediaAssetNodeFile {
    public static func create(
        folderId: String?,
        name: String,
        slug: String,
        slugPath: String,
        extension ext: String,
        contentType: String,
        sizeBytes: Int64,
        title: String?,
        altText: String?
    ) -> Self.New {
        .init(
            folderId: folderId,
            name: name,
            slug: slug,
            slugPath: slugPath,
            extension: ext,
            contentType: contentType,
            sizeBytes: sizeBytes,
            status: .uploaded,
            title: title,
            altText: altText
        )
    }
}
