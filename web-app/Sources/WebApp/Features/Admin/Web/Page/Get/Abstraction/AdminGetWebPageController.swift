import Hummingbird

protocol AdminGetWebPageController: Sendable {

    func getWebPage(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetWebPageController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/web/pages/{id}/",
            use: getWebPage
        )
    }
}
