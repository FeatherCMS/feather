import FeatherAdmin
import Hummingbird

protocol AdminListNewsletterCampaignsController: Sendable {
    func list(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
}

extension AdminListNewsletterCampaignsController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(NewsletterAdminRoutes.campaigns, use: list)
    }
}
