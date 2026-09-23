import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddContactFormController: Sendable {
    func add(request: Request, context: AuthenticatedRequestContext) async throws
        -> HTMLResponse
    func create(request: Request, context: AuthenticatedRequestContext) async throws
        -> Response
}

extension AdminAddContactFormController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(ContactAdminRoutes.formAdd, use: add)
        router.post(ContactAdminRoutes.formAdd, use: create)
    }
}
