import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactFieldController: Sendable {
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

extension AdminRemoveContactFieldController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(ContactAdminRoutes.fieldRemoveRoute, use: confirm)
        router.post(ContactAdminRoutes.fieldRemoveRoute, use: remove)
        router.get(ContactAdminRoutes.fieldRemove, use: confirmSelected)
        router.post(ContactAdminRoutes.fieldRemove, use: removeSelected)
    }
}
