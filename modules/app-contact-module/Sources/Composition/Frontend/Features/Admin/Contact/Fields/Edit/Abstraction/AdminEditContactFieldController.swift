import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditContactFieldController: Sendable {
    func edit(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminEditContactFieldController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(ContactAdminRoutes.fieldEditRoute, use: edit)
        router.post(ContactAdminRoutes.fieldEditRoute, use: update)
    }
}
