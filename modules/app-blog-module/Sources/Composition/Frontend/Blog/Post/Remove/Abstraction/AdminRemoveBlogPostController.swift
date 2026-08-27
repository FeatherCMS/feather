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

protocol AdminRemoveBlogPostController: Sendable {

    func getRemoveBlogPost(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postRemoveBlogPost(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveBlogPostController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/blog/posts/{id}/remove/",
            use: getRemoveBlogPost
        )
        router.post(
            "/admin/blog/posts/{id}/remove/",
            use: postRemoveBlogPost
        )
    }
}
