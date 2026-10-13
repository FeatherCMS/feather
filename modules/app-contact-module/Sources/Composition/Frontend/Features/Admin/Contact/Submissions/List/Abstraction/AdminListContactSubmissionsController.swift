import FeatherAdmin
import Hummingbird

protocol AdminListContactSubmissionsController: Sendable {
    func list(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
}

extension AdminListContactSubmissionsController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(ContactAdminRoutes.submissions, use: list)
    }
}
