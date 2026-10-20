import FeatherWebAdmin
import Hummingbird

protocol AdminRemoveNewsletterCampaignController: Sendable {
    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws -> Response
    func removeSelected(request: Request, context: AuthenticatedRequestContext)
        async throws -> Response
}

extension AdminRemoveNewsletterCampaignController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.post(
            NewsletterAdminRoutes.campaignRemoveSelected,
            use: removeSelected
        )
    }
}
