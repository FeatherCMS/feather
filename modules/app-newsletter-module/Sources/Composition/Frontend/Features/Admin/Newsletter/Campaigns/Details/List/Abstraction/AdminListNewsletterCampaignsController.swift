import FeatherAdmin
import Hummingbird

protocol AdminListNewsletterCampaignsController: Sendable {
    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminListNewsletterCampaignsController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(NewsletterAdminRoutes.campaigns, use: list)
    }
}
