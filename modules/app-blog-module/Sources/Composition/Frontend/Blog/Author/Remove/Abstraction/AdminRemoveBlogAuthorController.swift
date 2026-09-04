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

protocol AdminRemoveBlogAuthorController: Sendable {

    func getRemoveBlogAuthor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postRemoveBlogAuthor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveBlogAuthorController {

    func route(
        on router: Router<DefaultRequestContext>
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
