import FeatherAdmin
import Hummingbird

protocol AdminAddUserRoleController: Sendable {

    func getAddUserRole(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddUserRole(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddUserRoleController {

    func route(
        on router: Router<DefaultRequestContext>
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
