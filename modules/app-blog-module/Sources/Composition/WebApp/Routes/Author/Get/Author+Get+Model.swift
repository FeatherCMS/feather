import BlogAppAPI
public import BlogModule
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
public import WebModuleWebApp

extension Author.Get {
    public struct Model: Sendable {
        public let title: String
        public let subtitle: String
        public let imageURL: String?
        public let content: String
        public let links: [Author.Link.Model]
        public let posts: [Post.Summary.Model]
        public let metadata: AppPublicMetadataModel

        public init(
            title: String,
            subtitle: String,
            imageURL: String?,
            content: String,
            links: [Author.Link.Model],
            posts: [Post.Summary.Model],
            metadata: AppPublicMetadataModel
        ) {
            self.title = title
            self.subtitle = subtitle
            self.imageURL = imageURL
            self.content = content
            self.links = links
            self.posts = posts
            self.metadata = metadata
        }
    }
}
