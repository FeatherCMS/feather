import FeatherAdmin
import Hummingbird

protocol AdminGetUserRoleController: Sendable {

    func getUserRole(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetUserRoleController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RouterPath(UserRoleRoutes.detailsPattern.description + "/"),
            use: getUserRole
        )
    }
}
