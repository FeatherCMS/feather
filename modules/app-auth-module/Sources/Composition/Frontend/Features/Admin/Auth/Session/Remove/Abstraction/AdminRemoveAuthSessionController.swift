import FeatherAdmin
import Hummingbird

protocol AdminRemoveAuthSessionController: Sendable {

    func postRemoveAuthSession(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveAuthSessionController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.post(
            AuthSessionRoutes.remove(
                RouterPath("{id}"),
                sessionID: RouterPath("{sessionId}")
            ),
            use: postRemoveAuthSession
        )
    }
}
