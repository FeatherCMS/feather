import FeatherAdmin
import Hummingbird

protocol AdminViewNewsletterCampaignController: Sendable {
    func get(request: Request, context: AuthenticatedRequestContext) async throws
        -> HTMLResponse
}

extension AdminViewNewsletterCampaignController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(NewsletterAdminRoutes.campaignDetailsRoute, use: get)
    }
}
