import FeatherAdmin
import Hummingbird

protocol AdminAddUserRoleController: Sendable {

    func getAddUserRole(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddUserRole(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddUserRoleController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/user/roles/add/",
            use: getAddUserRole
        )
        router.post(
            "/admin/user/roles/add/",
            use: postAddUserRole
        )
    }
}
