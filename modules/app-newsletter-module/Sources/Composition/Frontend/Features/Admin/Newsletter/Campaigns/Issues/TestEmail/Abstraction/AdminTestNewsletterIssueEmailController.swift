import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminTestNewsletterIssueEmailController: Sendable {
    func send(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
}

extension AdminTestNewsletterIssueEmailController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.post(
            NewsletterAdminRoutes.issueTestEmailSelectedRoute,
            use: send
        )
        router.post(
            NewsletterAdminRoutes.issueTestEmailRoute,
            use: send
        )
    }
}
