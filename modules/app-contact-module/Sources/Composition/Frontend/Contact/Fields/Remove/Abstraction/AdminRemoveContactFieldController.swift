import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveContactFieldController: Sendable {
    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    func confirmSelected(request: Request, context: DefaultRequestContext)
        async throws
        -> HTMLResponse
    func removeSelected(request: Request, context: DefaultRequestContext)
        async throws
        -> Response
}

extension AdminRemoveContactFieldController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/contact/fields/:fieldId/remove/", use: confirm)
        router.post("/admin/contact/fields/:fieldId/remove/", use: remove)
        router.get("/admin/contact/fields/remove/", use: confirmSelected)
        router.post("/admin/contact/fields/remove/", use: removeSelected)
    }
}
