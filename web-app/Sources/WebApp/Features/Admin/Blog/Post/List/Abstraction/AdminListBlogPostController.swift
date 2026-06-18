import Hummingbird

protocol AdminListBlogPostController: Sendable {

    func getBlogPosts(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func getBlogPostsBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postBlogPostsBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postBlogPostStatus(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminListBlogPostController {

    func route(
        on router: Router<AppRequestContext>
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
