import FeatherAdmin
import Hummingbird

protocol AdminViewAnalyticsOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewAnalyticsOverviewController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/analytics/",
            use: getOverview
        )
    }
}
