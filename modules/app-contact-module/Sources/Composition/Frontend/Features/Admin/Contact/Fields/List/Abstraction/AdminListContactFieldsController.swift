import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListContactFieldsController: Sendable {
    func list(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
}

extension AdminListContactFieldsController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(ContactAdminRoutes.fields, use: list)
    }
}
