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

protocol AdminListBlogPostController: Sendable {

    func getBlogPosts(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getBlogPostsRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postBlogPostsRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postBlogPostStatus(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListBlogPostController {

    func route(
        on router: Router<DefaultRequestContext>
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
