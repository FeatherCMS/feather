import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddContactFieldController: Sendable {
    func getAddContactField(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    func postAddContactField(request: Request, context: DefaultRequestContext)
        async throws -> Response
}
extension AdminAddContactFieldController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(ContactAdminRoutes.fieldAdd, use: getAddContactField)
        router.post(ContactAdminRoutes.fieldAdd, use: postAddContactField)
    }
}
