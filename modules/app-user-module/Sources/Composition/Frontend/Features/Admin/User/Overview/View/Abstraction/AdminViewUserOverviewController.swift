import FeatherAdmin
import Hummingbird

protocol AdminViewUserOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewUserOverviewController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            UserAdminRoutes.user,
            use: getOverview
        )
    }
}
