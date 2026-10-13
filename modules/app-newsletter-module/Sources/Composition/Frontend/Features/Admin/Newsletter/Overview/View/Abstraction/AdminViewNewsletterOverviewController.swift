import FeatherAdmin
import Hummingbird

protocol AdminViewNewsletterOverviewController: Sendable {
    func getOverview(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewNewsletterOverviewController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(NewsletterAdminRoutes.newsletter, use: getOverview)
    }
}
