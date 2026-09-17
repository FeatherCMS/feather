public struct NewAdminMediaAssetVariant: Sendable, Equatable, Codable, Hashable
{
    public let name: String
    public let url: String
    public let `extension`: String

    public init(name: String, url: String, `extension`: String) {
        self.name = name
        self.url = url
        self.extension = `extension`
    }
}

public struct NewAdminMediaAsset: Sendable, Equatable, Codable, Hashable {
    public let id: String
    public let name: String
    public let slugPath: String
    public let url: String
    public let `extension`: String
    public let contentType: String
    public let sizeBytes: Int64
    public let variants: [NewAdminMediaAssetVariant]
    public let title: String?
    public let altText: String?
    public let status: String

    public init(
        id: String,
        name: String,
        slugPath: String,
        url: String,
        `extension`: String,
        contentType: String,
        sizeBytes: Int64,
        variants: [NewAdminMediaAssetVariant] = [],
        title: String?,
        altText: String?,
        status: String
    ) {
        self.id = id
        self.name = name
        self.slugPath = slugPath
        self.url = url
        self.extension = `extension`
        self.contentType = contentType
        self.sizeBytes = sizeBytes
        self.variants = variants
        self.title = title
        self.altText = altText
        self.status = status
    }

    public var originalURL: String { url }

    public var previewURL: String? {
        variants.first { $0.name == "image_preview" }?.url
    }
}
