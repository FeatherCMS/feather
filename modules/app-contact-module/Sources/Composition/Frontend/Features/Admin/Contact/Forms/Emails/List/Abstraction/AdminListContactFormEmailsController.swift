import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListContactFormEmailsController: Sendable {
    func list(request: Request, context: AuthenticatedRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactFormEmailsController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(ContactAdminRoutes.formEmailsRoute, use: list)
    }
}
