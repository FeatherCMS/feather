import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminListContactFormFieldsController: Sendable {
    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactFormFieldsController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/contact/forms/:formId/fields/", use: list)
    }
}
