import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListNewsletterIssuesController: Sendable {
    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminListNewsletterIssuesController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/newsletters/:newsletterId/issues/", use: list)
    }
}
