import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminViewNewsletterCampaignSubscriberController: Sendable {
    func get(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
}
extension AdminViewNewsletterCampaignSubscriberController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            NewsletterAdminRoutes.campaignSubscriberDetailsRoute,
            use: get
        )
    }
}
