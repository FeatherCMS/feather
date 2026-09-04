import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminRemoveContactFormSubmissionsController: Sendable {
    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    func confirmSelected(request: Request, context: DefaultRequestContext)
        async throws
        -> HTMLResponse
    func removeSelected(request: Request, context: DefaultRequestContext)
        async throws
        -> Response
}

extension AdminRemoveContactFormSubmissionsController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            "/admin/contact/forms/:formId/submissions/:submissionId/remove/",
            use: confirm
        )
        router.post(
            "/admin/contact/forms/:formId/submissions/:submissionId/remove/",
            use: remove
        )
        router.get(
            "/admin/contact/forms/:formId/submissions/remove/",
            use: confirmSelected
        )
        router.post(
            "/admin/contact/forms/:formId/submissions/remove/",
            use: removeSelected
        )
    }
}
