import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension AuthorLink.View {
    struct Model: Sendable {
        let id: String
        let authorID: String
        let label: String
        let url: String
        let priority: Int
        let isBlank: Bool
        let permission: String
        let notes: String
    }
}
