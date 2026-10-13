import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditNewsletterIssueController: Sendable {
    func get(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    func update(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
}

extension AdminEditNewsletterIssueController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            NewsletterAdminRoutes.issueEditRoute,
            use: get
        )
        router.post(
            NewsletterAdminRoutes.issueEditRoute,
            use: update
        )
    }
}
