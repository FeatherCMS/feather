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

protocol AdminAddBlogAuthorLinkPresenter: Sendable {

    func renderAddPage(
        menuId: String,
        state: BlogAuthorLinkForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        menuId: String
    ) -> AdminBreadcrumb.State
}
