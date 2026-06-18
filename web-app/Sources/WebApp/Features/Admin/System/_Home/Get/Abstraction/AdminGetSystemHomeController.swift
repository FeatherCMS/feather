import Hummingbird

protocol AdminGetSystemHomeController: Sendable {

    func getHome(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetSystemHomeController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/system/",
            use: getHome
        )
    }
}
