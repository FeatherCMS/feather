import FeatherAdmin
import Hummingbird

protocol AdminEditUserRoleController: Sendable {

    func getEditUserRole(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditUserRole(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditUserRoleController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/user/roles/{id}/edit/",
            use: getEditUserRole
        )
        router.post(
            "/admin/user/roles/{id}/edit/",
            use: postEditUserRole
        )
    }
}
