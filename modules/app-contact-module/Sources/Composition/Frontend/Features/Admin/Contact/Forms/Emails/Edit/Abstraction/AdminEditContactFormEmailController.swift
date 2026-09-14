import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditContactFormEmailController: Sendable {
    func edit(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminEditContactFormEmailController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            ContactAdminRoutes.formEmailEditRoute,
            use: edit
        )
        router.post(
            ContactAdminRoutes.formEmailEditRoute,
            use: update
        )
    }
}
