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

protocol AdminGetBlogAuthorController: Sendable {

    func getBlogAuthor(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetBlogAuthorController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/authors/{id}/",
            use: getBlogAuthor
        )
    }
}
