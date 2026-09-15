import FeatherAdmin
import Hummingbird

protocol AdminViewAnalyticsLogController: Sendable {

    func getAnalyticsLog(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewAnalyticsLogController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            AnalyticsAdminRoutes.log(RouterPath("{id}")),
            use: getAnalyticsLog
        )
    }
}
