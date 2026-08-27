import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveNewsletterCampaignSubscriberController: Sendable {
    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    func removeSelected(request: Request, context: DefaultRequestContext)
        async throws -> Response
}
extension AdminRemoveNewsletterCampaignSubscriberController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            "/admin/newsletters/:newsletterId/subscribers/:subscriberId/remove/",
            use: confirm
        )
        router.post(
            "/admin/newsletters/:newsletterId/subscribers/:subscriberId/remove/",
            use: remove
        )
        router.post(
            "/admin/newsletters/:newsletterId/subscribers/remove/",
            use: removeSelected
        )
    }
}
