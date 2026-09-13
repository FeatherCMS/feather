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
            "/admin/user/identities/{id}/remove/",
            use: getRemoveUserIdentity
        )
        router.post(
            "/admin/user/identities/{id}/remove/",
            use: postRemoveUserIdentity
        )
        router.get(
            "/admin/user/identities/remove/",
            use: getRemoveUserIdentities
        )
        router.post(
            "/admin/user/identities/remove/",
            use: postRemoveUserIdentities
        )
    }
}
