import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditContactFormController: Sendable {
    func edit(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    func update(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
}

extension AdminEditContactFormController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(ContactAdminRoutes.formEditRoute, use: edit)
        router.post(ContactAdminRoutes.formEditRoute, use: update)
    }
}
