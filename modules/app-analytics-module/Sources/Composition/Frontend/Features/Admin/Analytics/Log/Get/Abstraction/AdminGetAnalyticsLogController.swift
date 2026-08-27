import FeatherAdmin
import Hummingbird

protocol AdminGetAnalyticsLogController: Sendable {

    func getAnalyticsLog(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAnalyticsLogController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/analytics/logs/{id}/",
            use: getAnalyticsLog
        )
    }
}
