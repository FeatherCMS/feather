import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveNewsletterSubscribersController: Sendable {
    func confirm(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
}

extension AdminRemoveNewsletterSubscribersController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(NewsletterAdminRoutes.subscriberRemove, use: confirm)
        router.post(NewsletterAdminRoutes.subscriberRemove, use: remove)
    }
}
