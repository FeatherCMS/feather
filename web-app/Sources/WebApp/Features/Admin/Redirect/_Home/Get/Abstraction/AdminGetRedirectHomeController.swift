import Hummingbird

protocol AdminGetRedirectHomeController: Sendable {

    func getHome(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetRedirectHomeController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/redirect/",
            use: getHome
        )
    }
}
