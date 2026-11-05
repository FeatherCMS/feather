extension Page {
    public struct Definition: Sendable, Equatable {
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let metadata: Metadata?

        public init(
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String? = nil,
            metadata: Metadata? = nil
        ) {
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.metadata = metadata
        }
    }
}
