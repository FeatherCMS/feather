import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebStandards

protocol AdminEditBlogSettingsPresenter: Sendable {
    func renderPage(
        state: BlogSettingsEdit.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderDeniedPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse
}
