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
    enum Presenter {}
}

extension AuthorLink.View.Presenter {
    protocol Interface: Sendable {
        func renderDetailsPage(
            model: AuthorLink.Detail.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            authorID: String,
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
