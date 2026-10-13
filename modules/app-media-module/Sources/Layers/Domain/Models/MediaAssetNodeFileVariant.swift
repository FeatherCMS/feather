public import FeatherDomain

public import struct Foundation.Date

public struct MediaAssetNodeFileVariant: Model {
    public struct New: Sendable {
        public let assetNodeFileId: String
        public let variantId: String
        public let variantProcessorId: String
        public let storageObjectId: String
    }

    public let id: String
    public let assetNodeFileId: String
    public let variantId: String
    public let variantProcessorId: String
    public let storageObjectId: String
    public let createdAt: Date

    package init(
        id: String,
        assetNodeFileId: String,
        variantId: String,
        variantProcessorId: String,
        storageObjectId: String,
        createdAt: Date
    ) {
        self.id = id
        self.assetNodeFileId = assetNodeFileId
        self.variantId = variantId
        self.variantProcessorId = variantProcessorId
        self.storageObjectId = storageObjectId
        self.createdAt = createdAt
    }

    public static func create(
        assetNodeFileId: String,
        variantId: String,
        variantProcessorId: String,
        storageObjectId: String
    ) -> New {
        .init(
            assetNodeFileId: assetNodeFileId,
            variantId: variantId,
            variantProcessorId: variantProcessorId,
            storageObjectId: storageObjectId
        )
    }
}
