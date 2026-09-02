import FeatherAdmin
import Hummingbird

protocol AdminListUserIdentityController: Sendable {

    func getUserIdentities(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getUserIdentitiesRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postUserIdentitiesRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListUserIdentityController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/user/identities",
            use: getUserIdentities
        )
        router.get(
            "/admin/user/identities/remove/",
            use: getUserIdentitiesRemoveConfirmation
        )
        router.post(
            "/admin/user/identities/remove/",
            use: postUserIdentitiesRemove
        )
    }
}
