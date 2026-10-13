public import FeatherDomain

public import struct Foundation.Date

public struct MediaAssetStorageObject: Model {
    public struct New: Sendable {
        public let key: String
        public let `extension`: String
        public let contentType: String
        public let sizeInBytes: Int64
    }

    /// The ID used by media-asset variant relationships to reference this row.
    public let id: String
    public let key: String
    public let `extension`: String
    public let contentType: String
    public let sizeInBytes: Int64
    public let createdAt: Date

    public static func storageKey(
        assetID: String,
        key: String,
        extension: String,
        objectKeyGenerator: any ObjectKeyGenerator
    ) throws -> String {
        let shardPrefix = try objectKeyGenerator.generate(from: assetID)
        return "public/\(shardPrefix)/\(key).\(`extension`)"
    }

    package init(
        id: String,
        key: String,
        extension: String,
        contentType: String,
        sizeInBytes: Int64,
        createdAt: Date
    ) {
        self.id = id
        self.key = key
        self.extension = `extension`
        self.contentType = contentType
        self.sizeInBytes = sizeInBytes
        self.createdAt = createdAt
    }

    public static func create(
        key: String,
        extension: String,
        contentType: String,
        sizeInBytes: Int64
    ) -> New {
        .init(
            key: key,
            extension: `extension`,
            contentType: contentType,
            sizeInBytes: sizeInBytes
        )
    }
}
