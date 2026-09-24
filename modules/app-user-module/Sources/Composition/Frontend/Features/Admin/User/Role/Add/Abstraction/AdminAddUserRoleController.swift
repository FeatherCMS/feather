import FeatherAdmin
import Hummingbird

protocol AdminAddUserRoleController: Sendable {

    func getAddUserRole(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddUserRole(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddUserRoleController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            UserRoleRoutes.add,
            use: getAddUserRole
        )
        router.post(
            UserRoleRoutes.add,
            use: postAddUserRole
        )
    }
}
