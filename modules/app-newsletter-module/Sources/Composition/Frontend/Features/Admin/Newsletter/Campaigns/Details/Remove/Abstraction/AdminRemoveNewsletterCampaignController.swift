import FeatherAdmin
import Hummingbird

protocol AdminRemoveNewsletterCampaignController: Sendable {
    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    func removeSelected(request: Request, context: DefaultRequestContext)
        async throws -> Response
}

extension AdminRemoveNewsletterCampaignController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(NewsletterAdminRoutes.campaignRemoveRoute, use: confirm)
        router.post(NewsletterAdminRoutes.campaignRemoveRoute, use: remove)
        router.post(
            NewsletterAdminRoutes.campaignRemoveSelected,
            use: removeSelected
        )
    }
}
