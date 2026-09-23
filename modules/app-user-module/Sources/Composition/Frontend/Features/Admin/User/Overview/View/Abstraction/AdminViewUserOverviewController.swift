import FeatherAdmin
import Hummingbird

protocol AdminViewUserOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewUserOverviewController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            UserAdminRoutes.user,
            use: getOverview
        )
    }
}
