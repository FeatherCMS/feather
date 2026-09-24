import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveNewsletterCampaignSubscriberController: Sendable {
    func confirm(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    func removeSelected(request: Request, context: AuthenticatedRequestContext)
        async throws -> Response
}
extension AdminRemoveNewsletterCampaignSubscriberController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            NewsletterAdminRoutes.campaignSubscriberRemoveRoute,
            use: confirm
        )
        router.post(
            NewsletterAdminRoutes.campaignSubscriberRemoveRoute,
            use: remove
        )
        router.post(
            NewsletterAdminRoutes.campaignSubscriberRemoveSelectedRoute,
            use: removeSelected
        )
    }
}
