import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminEditContactFormEmailController: Sendable {
    func edit(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminEditContactFormEmailController {
    func route(on router: Router<AppRequestContext>) {
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
