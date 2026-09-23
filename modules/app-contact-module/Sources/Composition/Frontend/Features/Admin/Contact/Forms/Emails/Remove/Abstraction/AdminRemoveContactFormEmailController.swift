import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactFormEmailController: Sendable {
    func confirm(request: Request, context: AuthenticatedRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: AuthenticatedRequestContext) async throws
        -> Response
}

extension AdminRemoveContactFormEmailController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            ContactAdminRoutes.formEmailRemoveRoute,
            use: confirm
        )
        router.post(
            ContactAdminRoutes.formEmailRemoveRoute,
            use: remove
        )
    }
}
