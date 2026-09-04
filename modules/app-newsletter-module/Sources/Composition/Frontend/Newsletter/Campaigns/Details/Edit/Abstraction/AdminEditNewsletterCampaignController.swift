import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminEditNewsletterCampaignController: Sendable {
    func edit(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminEditNewsletterCampaignController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/newsletters/:newsletterId/edit/", use: edit)
        router.post("/admin/newsletters/:newsletterId/edit/", use: update)
    }
}
