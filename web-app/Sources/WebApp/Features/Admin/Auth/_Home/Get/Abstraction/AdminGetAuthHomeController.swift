import Hummingbird

protocol AdminGetAuthHomeController: Sendable {

    func getHome(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAuthHomeController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/auth/",
            use: getHome
        )
    }
}
