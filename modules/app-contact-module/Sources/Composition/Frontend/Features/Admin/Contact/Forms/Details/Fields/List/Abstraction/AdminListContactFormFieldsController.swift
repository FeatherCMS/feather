import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListContactFormFieldsController: Sendable {
    func list(request: Request, context: AuthenticatedRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactFormFieldsController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(ContactAdminRoutes.formFieldsRoute, use: list)
    }
}
