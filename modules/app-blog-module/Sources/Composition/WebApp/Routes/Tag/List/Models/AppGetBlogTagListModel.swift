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

public struct AppGetBlogTagListModel: Sendable {
    public let title: String
    public let items: [AppPublicTagSummaryModel]

    public init(title: String, items: [AppPublicTagSummaryModel]) {
        self.title = title
        self.items = items
    }
}
