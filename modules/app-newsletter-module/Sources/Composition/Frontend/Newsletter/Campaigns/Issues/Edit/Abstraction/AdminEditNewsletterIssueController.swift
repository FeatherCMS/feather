import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminEditNewsletterIssueController: Sendable {
    func get(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminEditNewsletterIssueController {
    func route(on router: Router<DefaultRequestContext>) {
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
