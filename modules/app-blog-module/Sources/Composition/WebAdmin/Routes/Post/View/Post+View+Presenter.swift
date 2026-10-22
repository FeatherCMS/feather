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

extension Post.View {
    enum Presenter {}
}

extension Post.View.Presenter {
    protocol Interface: Sendable {
        func renderDetailsPage(
            rule: Post.View.Detail.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
