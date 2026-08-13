import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveContactFormEmailController: Sendable {
    func confirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminRemoveContactFormEmailController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/contact/forms/:formId/emails/remove/",
            use: confirm
        )
        router.post(
            "/admin/contact/forms/:formId/emails/remove/",
            use: remove
        )
    }
}
