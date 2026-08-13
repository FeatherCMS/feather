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

public struct AppGetBlogAuthorListModel: Sendable {
    public let title: String
    public let items: [AppPublicAuthorSummaryModel]

    public init(title: String, items: [AppPublicAuthorSummaryModel]) {
        self.title = title
        self.items = items
    }
}
