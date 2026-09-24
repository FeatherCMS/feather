import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddContactFieldController: Sendable {
    func getAddContactField(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> HTMLResponse
    func postAddContactField(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> Response
}
extension AdminAddContactFieldController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(ContactAdminRoutes.fieldAdd, use: getAddContactField)
        router.post(ContactAdminRoutes.fieldAdd, use: postAddContactField)
    }
}
