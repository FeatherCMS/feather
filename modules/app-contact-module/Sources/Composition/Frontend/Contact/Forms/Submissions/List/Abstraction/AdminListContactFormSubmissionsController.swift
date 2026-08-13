import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListContactFormSubmissionsController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactFormSubmissionsController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/:formId/submissions/", use: list)
    }
}
