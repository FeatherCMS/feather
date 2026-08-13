import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AppNewsletterCampaignSubscriptionController: Sendable {
    func subscribe(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AppNewsletterCampaignSubscriptionController {
    func route(
        on router: Router<AppRequestContext>
    ) {
        router.post(
            "/newsletter/campaigns/:campaignId/subscribe",
            use: subscribe
        )
    }
}
