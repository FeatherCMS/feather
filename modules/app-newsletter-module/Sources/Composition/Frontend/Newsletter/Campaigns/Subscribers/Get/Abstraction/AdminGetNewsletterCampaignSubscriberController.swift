import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminGetNewsletterCampaignSubscriberController: Sendable {
    func get(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}
extension AdminGetNewsletterCampaignSubscriberController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/newsletters/:newsletterId/subscribers/:subscriberId/",
            use: get
        )
    }
}
