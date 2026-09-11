import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListContactFormEmailsController: Sendable {
    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactFormEmailsController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/contact/forms/:formId/emails/", use: list)
    }
}
