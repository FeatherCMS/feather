import FeatherAdmin
import Hummingbird

protocol AdminListAnalyticsLogController: Sendable {

    func getAnalyticsLogs(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListAnalyticsLogController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/analytics/logs/",
            use: getAnalyticsLogs
        )
    }
}
