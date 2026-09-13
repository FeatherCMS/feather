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
            UserRoleRoutes.edit(RouterPath("{id}")),
            use: getEditUserRole
        )
        router.post(
            UserRoleRoutes.edit(RouterPath("{id}")),
            use: postEditUserRole
        )
    }
}
