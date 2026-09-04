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

protocol AdminAddBlogPostPresenter: Sendable {

    func renderAddPage(
        state: BlogPostForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb() -> AdminBreadcrumb.State
}
