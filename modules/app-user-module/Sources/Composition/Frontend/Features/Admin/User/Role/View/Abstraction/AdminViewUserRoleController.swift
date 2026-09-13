import FeatherAdmin
import Hummingbird

protocol AdminViewUserRoleController: Sendable {

    func getUserRole(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewUserRoleController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            UserRoleRoutes.details(RouterPath("{id}")),
            use: getUserRole
        )
    }
}
