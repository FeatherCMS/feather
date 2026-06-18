import Hummingbird

protocol AdminGetBlogAuthorController: Sendable {

    func getBlogAuthor(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetBlogAuthorController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/authors/{id}/",
            use: getBlogAuthor
        )
    }
}
