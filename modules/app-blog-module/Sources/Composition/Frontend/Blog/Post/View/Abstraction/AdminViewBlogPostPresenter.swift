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

protocol AdminViewBlogPostPresenter: Sendable {

    func renderDetailsPage(
        rule: BlogPostDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
