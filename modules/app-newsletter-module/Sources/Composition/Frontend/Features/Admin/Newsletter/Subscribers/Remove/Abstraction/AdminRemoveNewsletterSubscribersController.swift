import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveNewsletterSubscribersController: Sendable {
    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws -> Response
}

extension AdminRemoveNewsletterSubscribersController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.post(NewsletterAdminRoutes.subscriberRemove, use: remove)
    }
}
