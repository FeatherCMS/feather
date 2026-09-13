import FeatherAdmin
import Hummingbird

protocol AdminListAuthSessionController: Sendable {
    func get(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListAuthSessionController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(
            AuthSessionRoutes.list(RouterPath("{id}")),
            use: get
        )
    }
}
