import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListContactFieldsController: Sendable {
    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactFieldsController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/contact/fields/", use: list)
    }
}
