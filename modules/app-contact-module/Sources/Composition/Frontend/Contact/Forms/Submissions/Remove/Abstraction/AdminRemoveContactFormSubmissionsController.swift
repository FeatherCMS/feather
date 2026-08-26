import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveContactFormSubmissionsController: Sendable {
    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    func bulkConfirm(request: Request, context: DefaultRequestContext)
        async throws
        -> HTMLResponse
    func bulkRemove(request: Request, context: DefaultRequestContext)
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
            use: bulkConfirm
        )
        router.post(
            "/admin/contact/forms/:formId/submissions/remove/",
            use: bulkRemove
        )
    }
}
