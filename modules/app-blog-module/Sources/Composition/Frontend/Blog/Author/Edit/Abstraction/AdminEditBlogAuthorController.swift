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

protocol AdminEditBlogAuthorController: Sendable {

    func getEditBlogAuthor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditBlogAuthor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditBlogAuthorController {

    func route(
        on router: Router<DefaultRequestContext>
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
