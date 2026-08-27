import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListContactFormsController: Sendable {
    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactFormsController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/contact/forms/", use: list)
    }
}
