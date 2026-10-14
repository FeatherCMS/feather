import FeatherAdmin
import Hummingbird

protocol AdminRemoveNewsletterCampaignSubscriberController: Sendable {
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

extension AdminRemoveNewsletterCampaignSubscriberController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.post(
            NewsletterAdminRoutes.campaignSubscriberRemoveSelectedRoute,
            use: removeSelected
        )
    }
}
