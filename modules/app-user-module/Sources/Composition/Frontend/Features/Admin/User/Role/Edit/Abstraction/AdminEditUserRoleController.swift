import FeatherAdmin
import Hummingbird

protocol AdminEditUserRoleController: Sendable {

    func getEditUserRole(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditUserRole(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditUserRoleController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
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
