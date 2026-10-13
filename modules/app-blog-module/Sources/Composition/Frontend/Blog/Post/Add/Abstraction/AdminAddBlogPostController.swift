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

protocol AdminAddBlogPostController: Sendable {

    func getAddBlogPost(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddBlogPost(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddBlogPostController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
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
