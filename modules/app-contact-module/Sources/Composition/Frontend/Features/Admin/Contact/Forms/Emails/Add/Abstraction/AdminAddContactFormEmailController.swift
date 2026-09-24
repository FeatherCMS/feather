import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddContactFormEmailController: Sendable {
    func add(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    func create(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
}

extension AdminAddContactFormEmailController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(ContactAdminRoutes.formEmailAddRoute, use: add)
        router.post(ContactAdminRoutes.formEmailAddRoute, use: create)
    }
}
