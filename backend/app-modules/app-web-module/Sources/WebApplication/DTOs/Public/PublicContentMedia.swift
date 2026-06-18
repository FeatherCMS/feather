import Application

public struct PublicContentMedia: DTO {
    public let assetId: String
    public let originalURL: String
    public let defaultURL: String
    public let variants: [PublicContentMediaVariant]

    public init(
        assetId: String,
        originalURL: String,
        defaultURL: String,
        variants: [PublicContentMediaVariant]
    ) {
        self.assetId = assetId
        self.originalURL = originalURL
        self.defaultURL = defaultURL
        self.variants = variants
    }
}
