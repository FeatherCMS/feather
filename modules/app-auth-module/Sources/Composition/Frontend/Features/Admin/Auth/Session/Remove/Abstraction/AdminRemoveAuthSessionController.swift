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
            AuthSessionRoutes.remove(
                RouterPath("{id}"),
                sessionID: RouterPath("{sessionId}")
            ),
            use: getRemoveAuthSession
        )
        router.post(
            AuthSessionRoutes.remove(
                RouterPath("{id}"),
                sessionID: RouterPath("{sessionId}")
            ),
            use: postRemoveAuthSession
        )
    }
}
