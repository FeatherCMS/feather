import Hummingbird

protocol AdminGetAnalyticsLogController: Sendable {

    func getAnalyticsLog(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAnalyticsLogController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/analytics/logs/{id}/",
            use: getAnalyticsLog
        )
    }
}
