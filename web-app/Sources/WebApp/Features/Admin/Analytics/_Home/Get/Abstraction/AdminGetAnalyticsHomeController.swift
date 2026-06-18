import Hummingbird

protocol AdminGetAnalyticsHomeController: Sendable {

    func getHome(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAnalyticsHomeController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/analytics/",
            use: getHome
        )
    }
}
