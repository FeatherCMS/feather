import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddNewsletterCampaignSubscriberController: Sendable {
    func add(request: Request, context: AuthenticatedRequestContext) async throws
        -> HTMLResponse
    func create(request: Request, context: AuthenticatedRequestContext) async throws
        -> Response
}
extension AdminAddNewsletterCampaignSubscriberController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            NewsletterAdminRoutes.campaignSubscriberAddRoute,
            use: add
        )
        router.post(
            NewsletterAdminRoutes.campaignSubscriberAddRoute,
            use: create
        )
    }
}
