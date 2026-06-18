import HTML
import Hummingbird

protocol AdminRemoveBlogPostController: Sendable {

    func getRemoveBlogPost(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveBlogPost(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveBlogPostController {

    func route(
        on router: Router<AppRequestContext>
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
