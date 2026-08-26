import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListContactFormSubmissionsController: Sendable {
    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactFormSubmissionsController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/contact/forms/:formId/submissions/", use: list)
    }
}
