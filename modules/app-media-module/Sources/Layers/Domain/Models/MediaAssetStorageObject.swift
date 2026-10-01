public import FeatherDomain

public import struct Foundation.Date

public struct MediaAssetStorageObject: Model {
    public struct New: Sendable {
        public let objectKey: String
    }

    public let id: String
    public let objectKey: String
    public let createdAt: Date
    public let deletedAt: Date?

    package init(
        id: String,
        objectKey: String,
        createdAt: Date,
        deletedAt: Date?
    ) {
        self.id = id
        self.objectKey = objectKey
        self.createdAt = createdAt
        self.deletedAt = deletedAt
    }

    public static func create(
        objectKey: String
    ) -> New {
        .init(objectKey: objectKey)
    }

    public static func originalObjectKey(
        assetID: String,
        fileExtension: String
    ) -> String {
        "\(assetID)/original.\(fileExtension)"
    }

    public static func variantObjectKey(
        assetID: String,
        variantKey: String,
        fileExtension: String
    ) -> String {
        "\(assetID)/variants/\(variantKey).\(fileExtension)"
    }
}
