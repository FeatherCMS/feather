import FeatherAdmin
import Hummingbird

protocol AdminViewAccountOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewAccountOverviewController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            RouterPath(AccountAdminRoutes.account.description + "/"),
            use: getOverview
        )
    }
}
