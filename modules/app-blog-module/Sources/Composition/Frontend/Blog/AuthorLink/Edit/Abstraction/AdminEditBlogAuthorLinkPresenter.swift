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

protocol AdminEditBlogAuthorLinkPresenter: Sendable {

    func renderEditPage(
        menuId: String,
        id: String,
        state: BlogAuthorLinkForm.State,
        isEdited: Bool,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        menuId: String,
        id: String
    ) -> AdminBreadcrumb.State
}
