import FeatherAdmin
import Hummingbird

protocol AdminGetAnalyticsHomeController: Sendable {

    func getHome(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAnalyticsHomeController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/analytics/",
            use: getHome
        )
    }
}
