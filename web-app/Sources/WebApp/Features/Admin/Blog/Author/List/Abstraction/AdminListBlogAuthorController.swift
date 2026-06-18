import Hummingbird

protocol AdminListBlogAuthorController: Sendable {

    func getBlogAuthors(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func getBlogAuthorsBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postBlogAuthorsBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postBlogAuthorStatus(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminListBlogAuthorController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/authors",
            use: getBlogAuthors
        )
        router.get(
            "/admin/blog/authors/bulk-remove/",
            use: getBlogAuthorsBulkRemoveConfirmation
        )
        router.post(
            "/admin/blog/authors/bulk-remove/",
            use: postBlogAuthorsBulkRemove
        )
        router.post(
            "/admin/blog/authors/{id}/status/",
            use: postBlogAuthorStatus
        )
    }
}
