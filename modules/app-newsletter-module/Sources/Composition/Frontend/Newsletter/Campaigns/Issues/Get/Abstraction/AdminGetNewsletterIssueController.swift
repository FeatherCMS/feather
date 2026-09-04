import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminGetNewsletterIssueController: Sendable {
    func get(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminGetNewsletterIssueController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            "/admin/newsletters/:newsletterId/issues/:issueId/",
            use: get
        )
    }
}
