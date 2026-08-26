import FeatherAdmin
import Hummingbird

protocol AdminListUserIdentityController: Sendable {

    func getUserIdentities(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getUserIdentitiesBulkRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postUserIdentitiesBulkRemove(
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
            "/admin/user/identities/bulk-remove/",
            use: getUserIdentitiesBulkRemoveConfirmation
        )
        router.post(
            "/admin/user/identities/bulk-remove/",
            use: postUserIdentitiesBulkRemove
        )
    }
}
