import FeatherAdmin
import Hummingbird

protocol AdminViewSystemJobController: Sendable {
    func getSystemJob(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewSystemJobController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            SystemJobRoutes.details(RouterPath("{id}")),
            use: getSystemJob
        )
    }
}
