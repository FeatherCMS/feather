import Hummingbird

protocol AdminGetUserHomeController: Sendable {

    func getHome(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetUserHomeController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/",
            use: getHome
        )
    }
}
