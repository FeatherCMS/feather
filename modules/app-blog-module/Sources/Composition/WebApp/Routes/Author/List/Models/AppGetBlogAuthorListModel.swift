import BlogAppAPI
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebApp

public struct AppGetBlogAuthorListModel: Sendable {
    public let title: String
    public let items: [AppPublicAuthorSummaryModel]

    public init(title: String, items: [AppPublicAuthorSummaryModel]) {
        self.title = title
        self.items = items
    }
}
