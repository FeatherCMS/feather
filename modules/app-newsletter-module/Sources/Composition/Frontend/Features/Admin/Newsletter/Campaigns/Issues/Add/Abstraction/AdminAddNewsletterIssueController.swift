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
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
    func postAddNewsletterIssue(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}
extension AdminAddNewsletterIssueController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
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
