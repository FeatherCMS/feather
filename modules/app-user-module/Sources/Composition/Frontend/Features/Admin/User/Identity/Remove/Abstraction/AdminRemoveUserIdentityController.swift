import FeatherAdmin
import Hummingbird

protocol AdminRemoveUserIdentityController: Sendable {

    func getRemoveUserIdentity(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postRemoveUserIdentity(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func getRemoveUserIdentities(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postRemoveUserIdentities(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveUserIdentityController {

    func route(
        on router: Router<DefaultRequestContext>
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
