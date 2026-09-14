import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminViewContactFormController: Sendable {
    func get(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminViewContactFormController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(ContactAdminRoutes.formDetailsRoute, use: get)
    }
}
