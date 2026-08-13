import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminEditNewsletterIssueController: Sendable {
    func get(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminEditNewsletterIssueController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/newsletters/:newsletterId/issues/:issueId/edit/",
            use: get
        )
        router.post(
            "/admin/newsletters/:newsletterId/issues/:issueId/edit/",
            use: update
        )
    }
}
