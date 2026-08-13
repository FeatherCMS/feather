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

protocol AdminEditBlogPostController: Sendable {

    func getEditBlogPost(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditBlogPost(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditBlogPostController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/posts/{id}/edit/",
            use: getEditBlogPost
        )
        router.post(
            "/admin/blog/posts/{id}/edit/",
            use: postEditBlogPost
        )
    }
}
