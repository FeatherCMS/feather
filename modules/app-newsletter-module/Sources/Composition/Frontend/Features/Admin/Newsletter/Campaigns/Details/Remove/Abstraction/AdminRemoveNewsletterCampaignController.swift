import FeatherAdmin
import Hummingbird

protocol AdminRemoveNewsletterCampaignController: Sendable {
    func confirm(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    func confirmSelected(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    func removeSelected(request: Request, context: AuthenticatedRequestContext)
        async throws -> Response
}

extension AdminRemoveNewsletterCampaignController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(NewsletterAdminRoutes.campaignRemove, use: confirmSelected)
        router.get(NewsletterAdminRoutes.campaignRemoveRoute, use: confirm)
        router.post(NewsletterAdminRoutes.campaignRemoveRoute, use: remove)
        router.post(
            NewsletterAdminRoutes.campaignRemoveSelected,
            use: removeSelected
        )
    }
}
