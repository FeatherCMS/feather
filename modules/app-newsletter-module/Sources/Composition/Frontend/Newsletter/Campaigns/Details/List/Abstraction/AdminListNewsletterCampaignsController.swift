import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminListNewsletterCampaignsController: Sendable {
    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminListNewsletterCampaignsController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/newsletters/", use: list)
    }
}
