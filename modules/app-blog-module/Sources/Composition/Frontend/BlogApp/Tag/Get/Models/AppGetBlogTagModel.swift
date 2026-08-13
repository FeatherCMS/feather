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
import WebStandards

public struct AppGetBlogTagModel: Sendable {
    public let title: String
    public let excerpt: String
    public let imageURL: String?
    public let content: String
    public let posts: [AppPublicPostSummaryModel]
    public let metadata: AppPublicMetadataModel

    public init(
        title: String,
        excerpt: String,
        imageURL: String?,
        content: String,
        posts: [AppPublicPostSummaryModel],
        metadata: AppPublicMetadataModel
    ) {
        self.title = title
        self.excerpt = excerpt
        self.imageURL = imageURL
        self.content = content
        self.posts = posts
        self.metadata = metadata
    }
}
