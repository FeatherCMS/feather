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

protocol AdminEditBlogAuthorPresenter: Sendable {

    func renderEditPage(
        id: String,
        state: BlogAuthorForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func breadcrumb(
        id: String
    ) -> [NewAdminBreadcrumb.Link]
}
