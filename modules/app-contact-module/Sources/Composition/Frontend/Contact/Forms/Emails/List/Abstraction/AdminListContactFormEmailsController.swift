import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListContactFormEmailsController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactFormEmailsController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/:formId/emails/", use: list)
    }
}
