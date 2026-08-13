import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminEditContactFieldController: Sendable {
    func edit(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminEditContactFieldController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/fields/:fieldId/edit/", use: edit)
        router.post("/admin/contact/fields/:fieldId/edit/", use: update)
    }
}
