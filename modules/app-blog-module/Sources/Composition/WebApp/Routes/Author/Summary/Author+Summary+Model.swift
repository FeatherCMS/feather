public import BlogModule
public import WebModuleWebApp

extension Author.Summary {
    public struct Model: Sendable {
        public let name: String
        public let excerpt: String
        public let href: String
        public let imageURL: String?
        public let metadata: AppPublicMetadataModel

        public init(
            name: String,
            excerpt: String,
            href: String,
            imageURL: String?,
            metadata: AppPublicMetadataModel
        ) {
            self.name = name
            self.excerpt = excerpt
            self.href = href
            self.imageURL = imageURL
            self.metadata = metadata
        }
    }
}
