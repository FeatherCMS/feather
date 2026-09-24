import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListNewsletterIssuesController: Sendable {
    func list(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
}

extension AdminListNewsletterIssuesController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(NewsletterAdminRoutes.issueListRoute, use: list)
    }
}
