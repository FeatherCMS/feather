import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminGetNewsletterCampaignSubscriberController: Sendable {
    func get(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}
extension AdminGetNewsletterCampaignSubscriberController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            NewsletterAdminRoutes.campaignSubscriberDetailsRoute,
            use: get
        )
    }
}
