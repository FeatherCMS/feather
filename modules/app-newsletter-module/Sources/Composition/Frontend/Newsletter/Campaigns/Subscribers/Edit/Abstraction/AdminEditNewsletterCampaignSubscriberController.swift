import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminEditNewsletterCampaignSubscriberController: Sendable {
    func edit(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: DefaultRequestContext) async throws
        -> Response
}
extension AdminEditNewsletterCampaignSubscriberController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            "/admin/newsletters/:newsletterId/subscribers/:subscriberId/edit/",
            use: edit
        )
        router.post(
            "/admin/newsletters/:newsletterId/subscribers/:subscriberId/edit/",
            use: update
        )
    }
}
