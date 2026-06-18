import Hummingbird

protocol AdminGetBlogAuthorLinkController: Sendable {

    func getBlogAuthorLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetBlogAuthorLinkController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/authors/{id}/links/{itemId}/",
            use: getBlogAuthorLink
        )
    }
}
