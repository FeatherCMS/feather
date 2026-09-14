import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminGetNewsletterIssueController: Sendable {
    func get(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminGetNewsletterIssueController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            NewsletterAdminRoutes.issueDetailsRoute,
            use: get
        )
    }
}
