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

protocol AdminAddBlogAuthorPresenter: Sendable {

    func renderAddPage(
        state: BlogAuthorForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb() -> AdminBreadcrumb.State
}
