import FeatherAdmin
import Hummingbird

protocol AdminViewContactOverviewController: Sendable {
    func getOverview(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewContactOverviewController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(ContactAdminRoutes.contact, use: getOverview)
    }
}
