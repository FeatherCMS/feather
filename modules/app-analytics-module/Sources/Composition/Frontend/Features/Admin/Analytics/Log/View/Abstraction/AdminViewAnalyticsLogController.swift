import FeatherAdmin
import Hummingbird

protocol AdminViewAnalyticsLogController: Sendable {

    func getAnalyticsLog(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewAnalyticsLogController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            AnalyticsAdminRoutes.log(RouterPath("{id}")),
            use: getAnalyticsLog
        )
    }
}
