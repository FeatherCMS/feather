import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AppNewsletterCampaignSubscriptionController: Sendable {
    func subscribe(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AppNewsletterCampaignSubscriptionController {
    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.post(
            "/newsletter/campaigns/:campaignId/subscribe",
            use: subscribe
        )
    }
}
