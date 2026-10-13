import FeatherAdmin
import Hummingbird

protocol AdminListUserRoleController: Sendable {

    func getUserRoles(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

}

extension AdminListUserRoleController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            UserRoleRoutes.list,
            use: getUserRoles
        )
    }
}
