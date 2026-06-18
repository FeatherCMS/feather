import Hummingbird

protocol AdminGetBlogHomeController: Sendable {

    func getHome(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetBlogHomeController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/",
            use: getHome
        )
    }
}
