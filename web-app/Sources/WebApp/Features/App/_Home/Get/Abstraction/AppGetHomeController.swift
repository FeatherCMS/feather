import Hummingbird

protocol AppGetHomeController: Sendable {

    func getHome(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AppGetHomeController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/",
            use: getHome
        )
    }
}
