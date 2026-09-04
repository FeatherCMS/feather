import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminAddNewsletterCampaignSubscriberController: Sendable {
    func add(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func create(request: Request, context: DefaultRequestContext) async throws
        -> Response
}
extension AdminAddNewsletterCampaignSubscriberController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            "/admin/newsletters/:newsletterId/subscribers/add/",
            use: add
        )
        router.post(
            "/admin/newsletters/:newsletterId/subscribers/add/",
            use: create
        )
    }
}
