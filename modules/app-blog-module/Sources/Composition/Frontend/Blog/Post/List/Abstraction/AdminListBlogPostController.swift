import BlogAdminAPI
import FeatherWebShared
import BlogAppAPI
import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

protocol AdminListBlogPostController: Sendable {

    func getBlogPosts(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse


    func postBlogPostStatus(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminListBlogPostController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/blog/posts",
            use: getBlogPosts
        )
        router.post(
            "/admin/blog/posts/{id}/status/",
            use: postBlogPostStatus
        )
    }
}
