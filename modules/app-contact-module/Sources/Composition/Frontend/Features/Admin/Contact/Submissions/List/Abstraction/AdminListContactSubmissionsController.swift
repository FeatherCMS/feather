import FeatherAdmin
import Hummingbird

protocol AdminListContactSubmissionsController: Sendable {
    func list(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactSubmissionsController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(ContactAdminRoutes.submissions, use: list)
    }
}
