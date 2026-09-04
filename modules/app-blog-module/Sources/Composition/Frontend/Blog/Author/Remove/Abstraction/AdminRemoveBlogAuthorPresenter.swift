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
import WebComponents
import WebBuilders

protocol AdminRemoveBlogAuthorPresenter: Sendable {

    func renderRemovePage(
        id: String,
        source: String,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State
}
