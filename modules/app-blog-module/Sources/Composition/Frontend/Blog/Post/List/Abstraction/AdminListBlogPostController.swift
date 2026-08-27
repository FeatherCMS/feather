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

protocol AdminListBlogPostController: Sendable {

    func getBlogPosts(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getBlogPostsBulkRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postBlogPostsBulkRemove(
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
            "/admin/blog/posts/bulk-remove/",
            use: getBlogPostsBulkRemoveConfirmation
        )
        router.post(
            "/admin/blog/posts/bulk-remove/",
            use: postBlogPostsBulkRemove
        )
        router.post(
            "/admin/blog/posts/{id}/status/",
            use: postBlogPostStatus
        )
    }
}
