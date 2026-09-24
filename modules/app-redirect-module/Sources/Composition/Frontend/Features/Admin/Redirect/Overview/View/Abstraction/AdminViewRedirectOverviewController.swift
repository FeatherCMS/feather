import FeatherAdmin
import Hummingbird

protocol AdminViewRedirectOverviewController: Sendable {

    func getOverview(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewRedirectOverviewController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            RedirectAdminRoutes.redirect,
            use: getOverview
        )
    }
}
