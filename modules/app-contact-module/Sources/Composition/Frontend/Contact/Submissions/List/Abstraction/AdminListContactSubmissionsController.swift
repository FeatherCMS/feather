import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListContactSubmissionsController: Sendable {
    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactSubmissionsController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/contact/submissions/", use: list)
    }
}
