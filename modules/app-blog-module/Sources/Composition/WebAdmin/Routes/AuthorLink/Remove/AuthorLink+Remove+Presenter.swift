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

extension AuthorLink.Remove {
    enum Presenter {}
}

extension AuthorLink.Remove.Presenter {
    protocol Interface: Sendable {
        func renderError(
            authorID: String,
            info: String,
            message: String
        ) async throws -> HTMLResponse
    }
}
