import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminAddContactFormEmailController: Sendable {
    func add(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func create(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminAddContactFormEmailController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/contact/forms/:formId/emails/add/", use: add)
        router.post("/admin/contact/forms/:formId/emails/add/", use: create)
    }
}
