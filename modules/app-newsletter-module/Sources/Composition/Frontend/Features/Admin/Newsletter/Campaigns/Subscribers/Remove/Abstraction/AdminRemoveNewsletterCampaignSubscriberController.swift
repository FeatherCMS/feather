import FeatherAdmin
import Hummingbird

protocol AdminRemoveNewsletterCampaignSubscriberController: Sendable {
    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws -> Response
    func removeSelected(request: Request, context: AuthenticatedRequestContext)
        async throws -> Response
}

extension AdminRemoveNewsletterCampaignSubscriberController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.post(
            NewsletterAdminRoutes.campaignSubscriberRemoveSelectedRoute,
            use: removeSelected
        )
    }
}
