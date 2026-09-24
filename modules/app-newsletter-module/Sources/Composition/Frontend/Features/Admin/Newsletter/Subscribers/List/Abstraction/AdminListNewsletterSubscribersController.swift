import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListNewsletterSubscribersController: Sendable {
    func list(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    func viewSubscriber(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListNewsletterSubscribersController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(NewsletterAdminRoutes.subscribers, use: list)
        router.get(
            NewsletterAdminRoutes.subscriberDetailsRoute,
            use: viewSubscriber
        )
    }
}
