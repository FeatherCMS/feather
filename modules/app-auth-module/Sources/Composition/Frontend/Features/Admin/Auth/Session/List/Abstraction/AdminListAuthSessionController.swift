import FeatherAdmin
import Hummingbird

protocol AdminListAuthSessionController: Sendable {
    func get(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListAuthSessionController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/user/identities/{id}/sessions/",
            use: get
        )
    }
}
