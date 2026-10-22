public struct WebPageDefinition: Sendable, Equatable {
    public let title: String
    public let excerpt: String
    public let content: String
    public let imageAssetId: String?
    public let metadata: WebPageMetadataDefinition?

    public init(
        title: String,
        excerpt: String,
        content: String,
        imageAssetId: String? = nil,
        metadata: WebPageMetadataDefinition? = nil
    ) {
        self.title = title
        self.excerpt = excerpt
        self.content = content
        self.imageAssetId = imageAssetId
        self.metadata = metadata
    }
}
