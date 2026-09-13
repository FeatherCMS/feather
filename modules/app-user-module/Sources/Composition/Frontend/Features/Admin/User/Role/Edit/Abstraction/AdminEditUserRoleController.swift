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
            RouterPath(UserRoleRoutes.editPattern.description + "/"),
            use: getEditUserRole
        )
        router.post(
            RouterPath(UserRoleRoutes.editPattern.description + "/"),
            use: postEditUserRole
        )
    }
}
