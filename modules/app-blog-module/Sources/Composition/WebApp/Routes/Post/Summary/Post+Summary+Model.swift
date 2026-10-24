public import BlogModule
public import WebModuleWebApp

extension Post.Summary {
    public struct Model: Sendable {
        public let title: String
        public let excerpt: String
        public let href: String
        public let publishedAt: String?
        public let metadata: Public.Metadata.Model

        public init(
            title: String,
            excerpt: String,
            href: String,
            publishedAt: String?,
            metadata: Public.Metadata.Model
        ) {
            self.title = title
            self.excerpt = excerpt
            self.href = href
            self.publishedAt = publishedAt
            self.metadata = metadata
        }
    }
}
