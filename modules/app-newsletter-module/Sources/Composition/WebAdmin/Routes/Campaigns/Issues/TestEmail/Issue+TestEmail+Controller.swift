import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Issue.TestEmail {
    enum Controller {
        protocol Interface: Sendable {
            func send(
                request: Request,
                context: AuthenticatedRequestContext
            ) async throws -> Response

            func route(
                on router: any RouterMethods<AuthenticatedRequestContext>,
                routes: Campaign.Router.Routes
            )
        }
    }
}

extension Issue.TestEmail.Controller.Interface {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>,
        routes: Campaign.Router.Routes
    ) {
        router.post(routes.issueTestEmail.routerPath, use: send)
        router.post(routes.issueDetailTestEmail.routerPath, use: send)
    }
}
