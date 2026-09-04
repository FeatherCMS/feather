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

public struct AppGetBlogTagListModel: Sendable {
    public let title: String
    public let items: [AppPublicTagSummaryModel]

    public init(title: String, items: [AppPublicTagSummaryModel]) {
        self.title = title
        self.items = items
    }
}
