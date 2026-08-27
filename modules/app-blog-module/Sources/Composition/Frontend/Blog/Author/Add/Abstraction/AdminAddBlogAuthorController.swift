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

protocol AdminAddBlogAuthorController: Sendable {

    func getAddBlogAuthor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddBlogAuthor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddBlogAuthorController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/blog/authors/add/",
            use: getAddBlogAuthor
        )
        router.post(
            "/admin/blog/authors/add/",
            use: postAddBlogAuthor
        )
    }
}
