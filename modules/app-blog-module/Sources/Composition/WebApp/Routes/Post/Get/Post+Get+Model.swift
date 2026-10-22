import BlogAppAPI
public import BlogModule
import HTML
import Hummingbird
import OpenAPIRuntime
import WebBuilders
import WebComponents
public import WebModuleWebApp

extension Post.Get {
    public struct Model: Sendable {
        public let title: String
        public let excerpt: String
        public let imageURL: String?
        public let content: String
        public let publishedAt: String?
        public let authors: [Author.Summary.Model]
        public let tags: [Tag.Summary.Model]
        public let metadata: AppPublicMetadataModel

        public init(
            title: String,
            excerpt: String,
            imageURL: String?,
            content: String,
            publishedAt: String?,
            authors: [Author.Summary.Model],
            tags: [Tag.Summary.Model],
            metadata: AppPublicMetadataModel
        ) {
            self.title = title
            self.excerpt = excerpt
            self.imageURL = imageURL
            self.content = content
            self.publishedAt = publishedAt
            self.authors = authors
            self.tags = tags
            self.metadata = metadata
        }
    }
}
