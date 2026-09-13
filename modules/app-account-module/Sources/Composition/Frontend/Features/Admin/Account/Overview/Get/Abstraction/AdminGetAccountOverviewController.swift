import FeatherAdmin
import Hummingbird

protocol AdminGetAccountOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAccountOverviewController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RouterPath(AccountAdminRoutes.account.description + "/"),
            use: getOverview
        )
    }
}
