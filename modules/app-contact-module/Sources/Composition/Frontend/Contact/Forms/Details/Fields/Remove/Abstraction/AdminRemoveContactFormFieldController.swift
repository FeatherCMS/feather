import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminRemoveContactFormFieldController: Sendable {
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
            use: confirmSelected
        )
        router.post(
            "/admin/contact/forms/:formId/fields/remove/",
            use: removeSelected
        )
    }
}
