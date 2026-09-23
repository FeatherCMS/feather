import FeatherAdmin
import Hummingbird

protocol AdminRemoveAuthSessionController: Sendable {

    func getRemoveAuthSession(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postRemoveAuthSession(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveAuthSessionController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
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
