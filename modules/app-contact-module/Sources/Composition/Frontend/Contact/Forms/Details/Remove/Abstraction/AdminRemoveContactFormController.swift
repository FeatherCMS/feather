import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveContactFormController: Sendable {
    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminRemoveContactFormController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/contact/forms/remove/", use: confirm)
        router.post("/admin/contact/forms/remove/", use: remove)
    }
}
