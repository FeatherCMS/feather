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

protocol AdminRemoveBlogAuthorController: Sendable {

    func getRemoveBlogAuthor(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postRemoveBlogAuthor(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveBlogAuthorController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/blog/authors/{id}/remove/",
            use: getRemoveBlogAuthor
        )
        router.post(
            "/admin/blog/authors/{id}/remove/",
            use: postRemoveBlogAuthor
        )
    }
}
