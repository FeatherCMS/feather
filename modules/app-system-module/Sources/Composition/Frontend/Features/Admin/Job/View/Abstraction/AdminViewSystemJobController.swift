import FeatherAdmin
import Hummingbird

protocol AdminViewSystemJobController: Sendable {
    func getSystemJob(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewSystemJobController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            SystemJobRoutes.details(RouterPath("{id}")),
            use: getSystemJob
        )
    }
}
