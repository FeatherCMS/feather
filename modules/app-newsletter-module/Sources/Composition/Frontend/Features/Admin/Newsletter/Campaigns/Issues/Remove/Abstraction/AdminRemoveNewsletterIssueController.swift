import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveNewsletterIssueController: Sendable {
    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminRemoveNewsletterIssueController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            NewsletterAdminRoutes.issueRemoveRoute,
            use: confirm
        )
        router.post(
            NewsletterAdminRoutes.issueRemoveRoute,
            use: remove
        )
    }
}
