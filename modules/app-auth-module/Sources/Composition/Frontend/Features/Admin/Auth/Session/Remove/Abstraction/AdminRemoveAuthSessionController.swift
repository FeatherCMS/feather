import FeatherAdmin
import Hummingbird

protocol AdminRemoveAuthSessionController: Sendable {

    func getRemoveAuthSession(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveAuthSession(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveAuthSessionController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/identities/{id}/sessions/{sessionId}/remove/",
            use: getRemoveAuthSession
        )
        router.post(
            "/admin/user/identities/{id}/sessions/{sessionId}/remove/",
            use: postRemoveAuthSession
        )
    }
}
