import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditContactFormEmailController: Sendable {
    func edit(request: Request, context: AuthenticatedRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: AuthenticatedRequestContext) async throws
        -> Response
}

extension AdminEditContactFormEmailController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            ContactAdminRoutes.formEmailEditRoute,
            use: edit
        )
        router.post(
            ContactAdminRoutes.formEmailEditRoute,
            use: update
        )
    }
}
