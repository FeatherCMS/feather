import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddContactFormController: Sendable {
    func add(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func create(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminAddContactFormController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(ContactAdminRoutes.formAdd, use: add)
        router.post(ContactAdminRoutes.formAdd, use: create)
    }
}
