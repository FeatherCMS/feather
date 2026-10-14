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

protocol AdminListBlogAuthorController: Sendable {

    func getBlogAuthors(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postBlogAuthorStatus(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminListBlogAuthorController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/blog/authors",
            use: getBlogAuthors
        )
        router.post(
            "/admin/blog/authors/{id}/status/",
            use: postBlogAuthorStatus
        )
    }
}
