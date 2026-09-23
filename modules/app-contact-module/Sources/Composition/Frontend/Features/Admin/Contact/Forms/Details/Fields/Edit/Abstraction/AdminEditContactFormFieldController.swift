import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditContactFormFieldController: Sendable {
    func edit(request: Request, context: AuthenticatedRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: AuthenticatedRequestContext) async throws
        -> Response
}

extension AdminEditContactFormFieldController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            ContactAdminRoutes.formFieldEditRoute,
            use: edit
        )
        router.post(
            ContactAdminRoutes.formFieldEditRoute,
            use: update
        )
    }
}
