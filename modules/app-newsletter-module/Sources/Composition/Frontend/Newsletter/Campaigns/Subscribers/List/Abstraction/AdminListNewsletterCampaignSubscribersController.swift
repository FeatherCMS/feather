import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListNewsletterCampaignSubscribersController: Sendable {
    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}
extension AdminListNewsletterCampaignSubscribersController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/newsletters/:newsletterId/subscribers/", use: list)
    }
}
