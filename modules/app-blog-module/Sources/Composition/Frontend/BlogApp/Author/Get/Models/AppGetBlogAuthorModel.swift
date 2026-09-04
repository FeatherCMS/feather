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

public struct AppGetBlogAuthorModel: Sendable {
    public let title: String
    public let subtitle: String
    public let imageURL: String?
    public let content: String
    public let links: [AppPublicAuthorLinkModel]
    public let posts: [AppPublicPostSummaryModel]
    public let metadata: AppPublicMetadataModel

    public init(
        title: String,
        subtitle: String,
        imageURL: String?,
        content: String,
        links: [AppPublicAuthorLinkModel],
        posts: [AppPublicPostSummaryModel],
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
