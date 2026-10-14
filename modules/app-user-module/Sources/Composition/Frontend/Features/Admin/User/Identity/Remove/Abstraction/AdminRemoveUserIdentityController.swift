import FeatherAdmin
import Hummingbird

protocol AdminRemoveUserIdentityController: Sendable {

    func postRemoveUserIdentity(
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
        router.post(
            UserIdentityRoutes.remove(RouterPath("{id}")),
            use: postRemoveUserIdentity
        )
        router.post(
            UserIdentityRoutes.remove,
            use: postRemoveUserIdentities
        )
    }
}
