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

protocol AdminAddBlogTagPresenter: Sendable {

    func renderAddPage(
        state: BlogTagForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb() -> AdminBreadcrumb.State
}
