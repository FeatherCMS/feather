import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactFormController: Sendable {
    func confirm(request: Request, context: AuthenticatedRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: AuthenticatedRequestContext) async throws
        -> Response
}

extension AdminRemoveContactFormController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(ContactAdminRoutes.formRemove, use: confirm)
        router.post(ContactAdminRoutes.formRemove, use: remove)
    }
}
