import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddContactFormFieldController: Sendable {
    func getAddContactFormField(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    func postAddContactFormField(request: Request, context: DefaultRequestContext)
        async throws -> Response
}
extension AdminAddContactFormFieldController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            "/admin/contact/forms/:formId/fields/add/",
            use: getAddContactFormField
        )
        router.post(
            "/admin/contact/forms/:formId/fields/add/",
            use: postAddContactFormField
        )
    }
}
