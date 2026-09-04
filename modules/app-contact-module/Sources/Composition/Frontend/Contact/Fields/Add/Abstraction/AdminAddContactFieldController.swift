import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminAddContactFieldController: Sendable {
    func getAddContactField(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    func postAddContactField(request: Request, context: DefaultRequestContext)
        async throws -> Response
}
extension AdminAddContactFieldController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/contact/fields/add/", use: getAddContactField)
        router.post("/admin/contact/fields/add/", use: postAddContactField)
    }
}
