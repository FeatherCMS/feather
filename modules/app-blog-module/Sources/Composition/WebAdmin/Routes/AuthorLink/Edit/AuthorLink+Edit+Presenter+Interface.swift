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

extension AuthorLink.Edit.Presenter {
    protocol Interface: Sendable {
        func renderEditPage(
            authorID: String,
            id: String,
            state: AuthorLink.Form.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            authorID: String,
            id: String,
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse

    }
}
