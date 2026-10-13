import FeatherAdmin
import Hummingbird

protocol AdminViewDashboardController: Sendable {

    func getHome(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewDashboardController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/",
            use: getHome
        )
    }
}
