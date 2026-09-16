public struct NewAdminMediaAssetVariant: Sendable, Equatable, Codable, Hashable
{
    public let name: String
    public let storageKey: String

    public init(name: String, storageKey: String) {
        self.name = name
        self.storageKey = NewAdminMediaAsset.normalizedStorageKey(storageKey)
    }
}

public struct NewAdminMediaAsset: Sendable, Equatable, Codable, Hashable {
    public let id: String
    public let storageKey: String
    public let baseName: String
    public let type: String
    public let variants: [NewAdminMediaAssetVariant]
    public let title: String?
    public let altText: String?
    public let status: String

    public init(
        id: String,
        storageKey: String,
        baseName: String,
        type: String,
        variants: [NewAdminMediaAssetVariant] = [],
        title: String?,
        altText: String?,
        status: String
    ) {
        self.id = id
        self.storageKey = Self.normalizedStorageKey(storageKey)
        self.baseName = baseName
        self.type = type
        self.variants = variants
        self.title = title
        self.altText = altText
        self.status = status
    }

    public var previewStorageKey: String? {
        variants.first { $0.name == "image_preview" }?.storageKey
    }

    public static func normalizedStorageKey(_ key: String) -> String {
        let prefix = "media/assets/"
        guard key.hasPrefix(prefix) else { return key }
        return String(key.dropFirst(prefix.count))
    }
}
