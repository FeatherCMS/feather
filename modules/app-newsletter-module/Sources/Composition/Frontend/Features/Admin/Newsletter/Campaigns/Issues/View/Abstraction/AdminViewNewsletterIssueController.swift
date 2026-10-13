import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminViewNewsletterIssueController: Sendable {
    func get(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
}

extension AdminViewNewsletterIssueController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            NewsletterAdminRoutes.issueDetailsRoute,
            use: get
        )
    }
}
