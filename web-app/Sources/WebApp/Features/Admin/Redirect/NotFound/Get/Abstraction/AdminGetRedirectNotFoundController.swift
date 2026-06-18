import Hummingbird

protocol AdminGetRedirectNotFoundController: Sendable {

    func getNotFound(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetRedirectNotFoundController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/redirect/404s/",
            use: getNotFound
        )
    }
}
