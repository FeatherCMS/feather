public import BlogModule
public import WebModuleWebApp

extension Tag.Summary {
    public struct Model: Sendable {
        public let title: String
        public let excerpt: String
        public let href: String
        public let imageURL: String?
        public let metadata: AppPublicMetadataModel
        public let exclusive: Bool

        public init(
            title: String,
            excerpt: String,
            href: String,
            imageURL: String?,
            metadata: AppPublicMetadataModel,
            exclusive: Bool
        ) {
            self.title = title
            self.excerpt = excerpt
            self.href = href
            self.imageURL = imageURL
            self.metadata = metadata
            self.exclusive = exclusive
        }
    }
}
