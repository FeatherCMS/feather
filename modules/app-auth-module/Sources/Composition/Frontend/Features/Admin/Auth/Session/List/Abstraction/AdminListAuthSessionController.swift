import FeatherAdmin
import Hummingbird

protocol AdminListAuthSessionController: Sendable {
    func get(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListAuthSessionController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            AuthSessionRoutes.list(RouterPath("{id}")),
            use: get
        )
    }
}
