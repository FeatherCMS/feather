import FeatherAdmin
import Hummingbird

protocol AdminListSystemJobController: Sendable {
    func getSystemJobs(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListSystemJobController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(SystemJobRoutes.list, use: getSystemJobs)
    }
}
