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

protocol AdminAddBlogPostController: Sendable {

    func getAddBlogPost(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddBlogPost(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddBlogPostController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/blog/posts/add/",
            use: getAddBlogPost
        )
        router.post(
            "/admin/blog/posts/add/",
            use: postAddBlogPost
        )
    }
}
