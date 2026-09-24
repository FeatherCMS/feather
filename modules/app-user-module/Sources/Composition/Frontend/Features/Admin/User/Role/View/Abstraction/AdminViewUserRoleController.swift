import FeatherAdmin
import Hummingbird

protocol AdminViewUserRoleController: Sendable {

    func getUserRole(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewUserRoleController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            UserRoleRoutes.details(RouterPath("{id}")),
            use: getUserRole
        )
    }
}
