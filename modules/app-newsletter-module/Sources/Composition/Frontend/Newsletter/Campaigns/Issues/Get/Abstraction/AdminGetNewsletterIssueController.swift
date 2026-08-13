import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminGetNewsletterIssueController: Sendable {
    func get(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminGetNewsletterIssueController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/newsletters/:newsletterId/issues/:issueId/",
            use: get
        )
    }
}
