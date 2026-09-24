import FeatherAdmin
import Hummingbird

protocol AdminEditNewsletterCampaignController: Sendable {
    func edit(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    func update(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
}

extension AdminEditNewsletterCampaignController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(NewsletterAdminRoutes.campaignEditRoute, use: edit)
        router.post(NewsletterAdminRoutes.campaignEditRoute, use: update)
    }
}
