import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddNewsletterCampaignController: Sendable {
    func getAddNewsletterCampaign(
        request: Request,
        context: DefaultRequestContext
    )
        async throws -> HTMLResponse
    func postAddNewsletterCampaign(
        request: Request,
        context: DefaultRequestContext
    )
        async throws -> Response
}

extension AdminAddNewsletterCampaignController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/newsletters/add/", use: getAddNewsletterCampaign)
        router.post("/admin/newsletters/add/", use: postAddNewsletterCampaign)
    }
}
