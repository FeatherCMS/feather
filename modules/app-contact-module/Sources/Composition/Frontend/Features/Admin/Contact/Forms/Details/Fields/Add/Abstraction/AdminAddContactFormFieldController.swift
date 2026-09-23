import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddContactFormFieldController: Sendable {
    func getAddContactFormField(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> HTMLResponse
    func postAddContactFormField(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> Response
}
extension AdminAddContactFormFieldController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            ContactAdminRoutes.formFieldAddRoute,
            use: getAddContactFormField
        )
        router.post(
            ContactAdminRoutes.formFieldAddRoute,
            use: postAddContactFormField
        )
    }
}
