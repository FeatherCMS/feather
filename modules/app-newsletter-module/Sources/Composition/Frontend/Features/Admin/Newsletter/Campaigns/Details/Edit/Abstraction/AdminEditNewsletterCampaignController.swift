import FeatherAdmin
import Hummingbird

protocol AdminEditNewsletterCampaignController: Sendable {
    func edit(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminEditNewsletterCampaignController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(NewsletterAdminRoutes.campaignEditRoute, use: edit)
        router.post(NewsletterAdminRoutes.campaignEditRoute, use: update)
    }
}
