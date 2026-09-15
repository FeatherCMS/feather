import FeatherAdmin
import Hummingbird

protocol AdminListUserRoleController: Sendable {

    func getUserRoles(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

}

extension AdminListUserRoleController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            UserRoleRoutes.list,
            use: getUserRoles
        )
    }
}
