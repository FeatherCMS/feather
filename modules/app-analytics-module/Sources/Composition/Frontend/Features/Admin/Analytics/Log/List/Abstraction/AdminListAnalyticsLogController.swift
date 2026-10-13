import FeatherAdmin
import Hummingbird

protocol AdminListAnalyticsLogController: Sendable {

    func getAnalyticsLogs(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListAnalyticsLogController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            AnalyticsAdminRoutes.logs,
            use: getAnalyticsLogs
        )
    }
}
