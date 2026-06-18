import Hummingbird

protocol AdminListAnalyticsLogController: Sendable {

    func getAnalyticsLogs(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListAnalyticsLogController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/analytics/logs/",
            use: getAnalyticsLogs
        )
    }
}
