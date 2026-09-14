import FeatherAdmin
import Hummingbird

protocol AdminViewContactOverviewController: Sendable {
    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewContactOverviewController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(ContactAdminRoutes.contact, use: getOverview)
    }
}
