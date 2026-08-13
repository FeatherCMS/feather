import FeatherAdmin
import Hummingbird

protocol AdminListUserIdentityController: Sendable {

    func getUserIdentities(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func getUserIdentitiesBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postUserIdentitiesBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminListUserIdentityController {

    func route(
        on router: Router<AppRequestContext>
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
