import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveNewsletterIssueController: Sendable {
    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminRemoveNewsletterIssueController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            "/admin/newsletters/:newsletterId/issues/:issueId/remove/",
            use: confirm
        )
        router.post(
            "/admin/newsletters/:newsletterId/issues/:issueId/remove/",
            use: remove
        )
    }
}
