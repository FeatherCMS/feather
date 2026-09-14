import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddNewsletterIssueController: Sendable {
    func getAddNewsletterIssue(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
    func postAddNewsletterIssue(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}
extension AdminAddNewsletterIssueController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            NewsletterAdminRoutes.issueAddRoute,
            use: getAddNewsletterIssue
        )
        router.post(
            NewsletterAdminRoutes.issueAddRoute,
            use: postAddNewsletterIssue
        )
    }
}
