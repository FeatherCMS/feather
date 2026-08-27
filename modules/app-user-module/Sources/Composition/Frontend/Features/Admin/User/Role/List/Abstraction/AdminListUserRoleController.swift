import FeatherAdmin
import Hummingbird

protocol AdminListUserRoleController: Sendable {

    func getUserRoles(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getUserRolesBulkRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postUserRolesBulkRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListUserRoleController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/user/roles",
            use: getUserRoles
        )
        router.get(
            "/admin/user/roles/bulk-remove/",
            use: getUserRolesBulkRemoveConfirmation
        )
        router.post(
            "/admin/user/roles/bulk-remove/",
            use: postUserRolesBulkRemove
        )
    }
}
