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

public struct AppGetBlogPostListModel: Sendable {
    public let title: String
    public let items: [AppPublicPostSummaryModel]

    public init(title: String, items: [AppPublicPostSummaryModel]) {
        self.title = title
        self.items = items
    }
}
