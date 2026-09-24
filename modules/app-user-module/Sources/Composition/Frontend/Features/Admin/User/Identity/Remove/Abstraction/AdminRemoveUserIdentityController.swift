import FeatherAdmin
import Hummingbird

protocol AdminRemoveUserIdentityController: Sendable {

    func getRemoveUserIdentity(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postRemoveUserIdentity(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func getRemoveUserIdentities(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postRemoveUserIdentities(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveUserIdentityController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            UserIdentityRoutes.remove(RouterPath("{id}")),
            use: getRemoveUserIdentity
        )
        router.post(
            UserIdentityRoutes.remove(RouterPath("{id}")),
            use: postRemoveUserIdentity
        )
        router.get(
            UserIdentityRoutes.remove,
            use: getRemoveUserIdentities
        )
        router.post(
            UserIdentityRoutes.remove,
            use: postRemoveUserIdentities
        )
    }
}
