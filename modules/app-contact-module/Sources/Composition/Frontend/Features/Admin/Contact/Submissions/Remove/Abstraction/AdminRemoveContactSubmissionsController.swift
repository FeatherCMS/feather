import FeatherAdmin
import Hummingbird

protocol AdminRemoveContactSubmissionsController: Sendable {
    func confirm(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
}

extension AdminRemoveContactSubmissionsController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(ContactAdminRoutes.submissionRemove, use: confirm)
        router.post(ContactAdminRoutes.submissionRemove, use: remove)
    }
}
