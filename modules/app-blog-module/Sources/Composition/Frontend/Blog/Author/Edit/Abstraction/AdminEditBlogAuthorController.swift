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

protocol AdminEditBlogAuthorController: Sendable {

    func getEditBlogAuthor(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditBlogAuthor(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditBlogAuthorController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/blog/authors/{id}/edit/",
            use: getEditBlogAuthor
        )
        router.post(
            "/admin/blog/authors/{id}/edit/",
            use: postEditBlogAuthor
        )
    }
}
