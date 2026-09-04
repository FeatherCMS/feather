import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminAddContactFormController: Sendable {
    func add(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func create(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminAddContactFormController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/contact/forms/add/", use: add)
        router.post("/admin/contact/forms/add/", use: create)
    }
}
