import Hummingbird

protocol AdminGetWebHomeController: Sendable {

    func getHome(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetWebHomeController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/web/",
            use: getHome
        )
    }
}
