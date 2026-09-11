import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminGetNewsletterCampaignController: Sendable {
    func get(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminGetNewsletterCampaignController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/newsletters/:newsletterId/details/", use: get)
    }
}
