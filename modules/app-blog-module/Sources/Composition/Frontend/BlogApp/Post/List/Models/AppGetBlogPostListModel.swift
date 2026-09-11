import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

public struct AppGetBlogPostListModel: Sendable {
    public let title: String
    public let items: [AppPublicPostSummaryModel]

    public init(title: String, items: [AppPublicPostSummaryModel]) {
        self.title = title
        self.items = items
    }
}
