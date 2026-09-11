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

protocol AdminGetBlogPostController: Sendable {

    func getBlogPost(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetBlogPostController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/blog/posts/{id}/",
            use: getBlogPost
        )
    }
}
