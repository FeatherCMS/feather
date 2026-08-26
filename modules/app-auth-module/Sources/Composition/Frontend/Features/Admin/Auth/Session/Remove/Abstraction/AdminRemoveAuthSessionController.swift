import FeatherAdmin
import Hummingbird

protocol AdminRemoveAuthSessionController: Sendable {

    func getRemoveAuthSession(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postRemoveAuthSession(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveAuthSessionController {

    func route(
        on router: Router<DefaultRequestContext>
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
