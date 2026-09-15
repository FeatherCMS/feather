import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

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
            ContactAdminRoutes.formFieldRemoveRoute,
            use: confirm
        )
        router.post(
            ContactAdminRoutes.formFieldRemoveRoute,
            use: remove
        )
        router.get(
            ContactAdminRoutes.formFieldRemoveSelectedRoute,
            use: confirmSelected
        )
        router.post(
            ContactAdminRoutes.formFieldRemoveSelectedRoute,
            use: removeSelected
        )
    }
}
