import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListContactSubmissionsController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactSubmissionsController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/submissions/", use: list)
    }
}
