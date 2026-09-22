import FeatherAdmin
import Hummingbird

protocol AdminRemoveContactSubmissionsController: Sendable {
    func confirm(request: Request, context: DefaultRequestContext)
        async throws
        -> HTMLResponse
    func remove(request: Request, context: DefaultRequestContext)
        async throws
        -> Response
}

extension AdminRemoveContactSubmissionsController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(ContactAdminRoutes.submissionRemove, use: confirm)
        router.post(ContactAdminRoutes.submissionRemove, use: remove)
    }
}
