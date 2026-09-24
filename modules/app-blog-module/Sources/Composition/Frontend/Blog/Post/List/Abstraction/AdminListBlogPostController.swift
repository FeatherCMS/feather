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

protocol AdminListBlogPostController: Sendable {

    func getBlogPosts(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func getBlogPostsRemoveConfirmation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postBlogPostsRemove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

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
        router.get(
            "/admin/blog/posts/remove/",
            use: getBlogPostsRemoveConfirmation
        )
        router.post(
            "/admin/blog/posts/remove/",
            use: postBlogPostsRemove
        )
        router.post(
            "/admin/blog/posts/{id}/status/",
            use: postBlogPostStatus
        )
    }
}
