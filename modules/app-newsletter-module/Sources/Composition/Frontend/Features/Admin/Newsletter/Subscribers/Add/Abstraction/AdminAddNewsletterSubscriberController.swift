import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddNewsletterSubscriberController: Sendable {
    func get(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    func post(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
}

extension AdminAddNewsletterSubscriberController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(NewsletterAdminRoutes.subscriberAdd, use: get)
        router.post(NewsletterAdminRoutes.subscriberAdd, use: post)
    }
}
