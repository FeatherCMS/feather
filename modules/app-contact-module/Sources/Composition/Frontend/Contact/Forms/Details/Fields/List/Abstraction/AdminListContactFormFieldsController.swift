import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListContactFormFieldsController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactFormFieldsController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/:formId/fields/", use: list)
    }
}
