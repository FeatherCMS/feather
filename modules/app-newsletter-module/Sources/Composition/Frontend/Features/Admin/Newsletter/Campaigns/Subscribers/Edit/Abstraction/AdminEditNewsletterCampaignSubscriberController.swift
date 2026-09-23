import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditNewsletterCampaignSubscriberController: Sendable {
    func edit(request: Request, context: AuthenticatedRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: AuthenticatedRequestContext) async throws
        -> Response
}
extension AdminEditNewsletterCampaignSubscriberController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            NewsletterAdminRoutes.campaignSubscriberEditRoute,
            use: edit
        )
        router.post(
            NewsletterAdminRoutes.campaignSubscriberEditRoute,
            use: update
        )
    }
}
