import HTML
import Hummingbird

protocol AdminAddBlogPostController: Sendable {

    func getAddBlogPost(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddBlogPost(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddBlogPostController {

    func route(
        on router: Router<AppRequestContext>
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
