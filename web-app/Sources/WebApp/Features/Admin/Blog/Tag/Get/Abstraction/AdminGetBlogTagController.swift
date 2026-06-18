import Hummingbird

protocol AdminGetBlogTagController: Sendable {

    func getBlogTag(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetBlogTagController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/tags/{id}/",
            use: getBlogTag
        )
    }
}
