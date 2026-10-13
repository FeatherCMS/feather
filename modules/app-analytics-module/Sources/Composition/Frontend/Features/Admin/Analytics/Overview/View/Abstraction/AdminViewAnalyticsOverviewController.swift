import FeatherAdmin
import Hummingbird

protocol AdminViewAnalyticsOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewAnalyticsOverviewController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/analytics/",
            use: getOverview
        )
    }
}
