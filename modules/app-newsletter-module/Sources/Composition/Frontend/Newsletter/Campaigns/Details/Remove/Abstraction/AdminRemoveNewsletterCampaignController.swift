import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveNewsletterCampaignController: Sendable {
    func confirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
    func removeSelected(request: Request, context: AppRequestContext)
        async throws -> Response
}

extension AdminRemoveNewsletterCampaignController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/:newsletterId/remove/", use: confirm)
        router.post("/admin/newsletters/:newsletterId/remove/", use: remove)
        router.post("/admin/newsletters/remove/", use: removeSelected)
    }
}
