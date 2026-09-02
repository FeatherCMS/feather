import FeatherAdmin
import Hummingbird

protocol AdminListUserRoleController: Sendable {

    func getUserRoles(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getUserRolesRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postUserRolesRemove(
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
            "/admin/user/roles/remove/",
            use: getUserRolesRemoveConfirmation
        )
        router.post(
            "/admin/user/roles/remove/",
            use: postUserRolesRemove
        )
    }
}
