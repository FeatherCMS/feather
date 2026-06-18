import Hummingbird

protocol AdminGetBlogPostController: Sendable {

    func getBlogPost(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetBlogPostController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/posts/{id}/",
            use: getBlogPost
        )
    }
}
