import FeatherAdmin
import Hummingbird

protocol AdminViewNewsletterOverviewController: Sendable {
    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewNewsletterOverviewController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(NewsletterAdminRoutes.newsletter, use: getOverview)
    }
}
