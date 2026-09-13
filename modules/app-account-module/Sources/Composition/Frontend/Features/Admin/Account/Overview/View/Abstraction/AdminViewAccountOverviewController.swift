import FeatherAdmin
import Hummingbird

protocol AdminViewAccountOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewAccountOverviewController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RouterPath(AccountAdminRoutes.account.description + "/"),
            use: getOverview
        )
    }
}
