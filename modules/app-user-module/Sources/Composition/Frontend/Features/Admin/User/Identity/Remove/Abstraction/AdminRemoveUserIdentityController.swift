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
            RouterPath(UserIdentityRoutes.removePattern.description + "/"),
            use: getRemoveUserIdentity
        )
        router.post(
            RouterPath(UserIdentityRoutes.removePattern.description + "/"),
            use: postRemoveUserIdentity
        )
        router.get(
            RouterPath(UserIdentityRoutes.remove.description + "/"),
            use: getRemoveUserIdentities
        )
        router.post(
            RouterPath(UserIdentityRoutes.remove.description + "/"),
            use: postRemoveUserIdentities
        )
    }
}
