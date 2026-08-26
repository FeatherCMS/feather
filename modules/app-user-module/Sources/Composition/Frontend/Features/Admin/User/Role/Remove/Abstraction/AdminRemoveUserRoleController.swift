import FeatherAdmin
import Hummingbird

protocol AdminRemoveUserRoleController: Sendable {

    func getRemoveUserRole(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postRemoveUserRole(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveUserRoleController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/user/roles/{id}/remove/",
            use: getRemoveUserRole
        )
        router.post(
            "/admin/user/roles/{id}/remove/",
            use: postRemoveUserRole
        )
    }
}
