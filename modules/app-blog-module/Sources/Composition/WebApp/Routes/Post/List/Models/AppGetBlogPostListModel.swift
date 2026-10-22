import BlogAppAPI
import HTML
import Hummingbird
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
