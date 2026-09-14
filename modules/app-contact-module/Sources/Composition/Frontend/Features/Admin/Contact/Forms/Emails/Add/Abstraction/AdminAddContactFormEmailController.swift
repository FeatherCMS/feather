import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddContactFormEmailController: Sendable {
    func add(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func create(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminAddContactFormEmailController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(ContactAdminRoutes.formEmailAddRoute, use: add)
        router.post(ContactAdminRoutes.formEmailAddRoute, use: create)
    }
}
