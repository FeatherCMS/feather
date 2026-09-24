import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactFormSubmissionsController: Sendable {
    func confirm(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    func confirmSelected(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    func removeSelected(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
}

extension AdminRemoveContactFormSubmissionsController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            ContactAdminRoutes.formSubmissionRemoveRoute,
            use: confirm
        )
        router.post(
            ContactAdminRoutes.formSubmissionRemoveRoute,
            use: remove
        )
        router.get(
            ContactAdminRoutes.formSubmissionRemoveSelectedRoute,
            use: confirmSelected
        )
        router.post(
            ContactAdminRoutes.formSubmissionRemoveSelectedRoute,
            use: removeSelected
        )
    }
}
