import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminEditContactFieldController: Sendable {
    func edit(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminEditContactFieldController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/contact/fields/:fieldId/edit/", use: edit)
        router.post("/admin/contact/fields/:fieldId/edit/", use: update)
    }
}
