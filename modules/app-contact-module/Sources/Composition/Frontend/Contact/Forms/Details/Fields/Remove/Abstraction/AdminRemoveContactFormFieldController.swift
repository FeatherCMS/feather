import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveContactFormFieldController: Sendable {
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

extension AdminRemoveContactFormFieldController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            "/admin/contact/forms/:formId/fields/:fieldId/remove/",
            use: confirm
        )
        router.post(
            "/admin/contact/forms/:formId/fields/:fieldId/remove/",
            use: remove
        )
        router.get(
            "/admin/contact/forms/:formId/fields/remove/",
            use: bulkConfirm
        )
        router.post(
            "/admin/contact/forms/:formId/fields/remove/",
            use: bulkRemove
        )
    }
}
