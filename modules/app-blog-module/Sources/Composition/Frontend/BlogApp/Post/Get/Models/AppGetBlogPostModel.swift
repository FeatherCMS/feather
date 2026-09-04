import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

public struct AppGetBlogPostModel: Sendable {
    public let title: String
    public let excerpt: String
    public let imageURL: String?
    public let content: String
    public let publishedAt: String?
    public let authors: [AppPublicAuthorSummaryModel]
    public let tags: [AppPublicTagSummaryModel]
    public let metadata: AppPublicMetadataModel

    public init(
        title: String,
        excerpt: String,
        imageURL: String?,
        content: String,
        publishedAt: String?,
        authors: [AppPublicAuthorSummaryModel],
        tags: [AppPublicTagSummaryModel],
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
