import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

protocol AdminEditBlogSettingsPresenter: Sendable {
    func renderPage(
        state: BlogSettingsEdit.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderDeniedPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
