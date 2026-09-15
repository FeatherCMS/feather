import FeatherAdmin
import Hummingbird

protocol AdminListSystemJobController: Sendable {
    func getSystemJobs(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListSystemJobController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(SystemJobRoutes.list, use: getSystemJobs)
    }
}
