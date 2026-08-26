import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveContactSubmissionsController: Sendable {
    func bulkConfirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func bulkRemove(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminRemoveContactSubmissionsController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/contact/submissions/remove/", use: bulkConfirm)
        router.post("/admin/contact/submissions/remove/", use: bulkRemove)
    }
}
