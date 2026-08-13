import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListNewsletterCampaignsController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminListNewsletterCampaignsController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/", use: list)
    }
}
