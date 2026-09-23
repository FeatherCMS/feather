import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListNewsletterCampaignSubscribersController: Sendable {
    func list(request: Request, context: AuthenticatedRequestContext) async throws
        -> HTMLResponse
}
extension AdminListNewsletterCampaignSubscribersController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(NewsletterAdminRoutes.campaignSubscriberListRoute, use: list)
    }
}
