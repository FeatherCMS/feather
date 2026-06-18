import Hummingbird

protocol AdminGetHomeController: Sendable {

    func getHome(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetHomeController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/",
            use: getHome
        )
    }
}
