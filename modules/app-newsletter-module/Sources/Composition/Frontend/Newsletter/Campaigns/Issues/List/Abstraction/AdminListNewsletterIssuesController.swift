import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListNewsletterIssuesController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminListNewsletterIssuesController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/:newsletterId/issues/", use: list)
    }
}
