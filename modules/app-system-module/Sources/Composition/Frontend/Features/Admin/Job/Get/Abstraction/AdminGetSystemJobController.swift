import FeatherAdmin
import Hummingbird

protocol AdminGetSystemJobController: Sendable {
    func getSystemJob(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetSystemJobController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            SystemJobRoutes.details(RouterPath("{id}")),
            use: getSystemJob
        )
    }
}
