import Hummingbird

protocol AdminListBlogTagController: Sendable {

    func getBlogTags(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func getBlogTagsBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postBlogTagsBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postBlogTagStatus(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminListBlogTagController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/tags",
            use: getBlogTags
        )
        router.get(
            "/admin/blog/tags/bulk-remove/",
            use: getBlogTagsBulkRemoveConfirmation
        )
        router.post(
            "/admin/blog/tags/bulk-remove/",
            use: postBlogTagsBulkRemove
        )
        router.post(
            "/admin/blog/tags/{id}/status/",
            use: postBlogTagStatus
        )
    }
}
