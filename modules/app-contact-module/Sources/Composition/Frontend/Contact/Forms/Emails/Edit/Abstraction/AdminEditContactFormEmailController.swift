import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminEditContactFormEmailController: Sendable {
    func edit(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: DefaultRequestContext) async throws
        -> Response
}

extension AdminEditContactFormEmailController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            "/admin/contact/forms/:formId/emails/:mailId/edit/",
            use: edit
        )
        router.post(
            "/admin/contact/forms/:formId/emails/:mailId/edit/",
            use: update
        )
    }
}
