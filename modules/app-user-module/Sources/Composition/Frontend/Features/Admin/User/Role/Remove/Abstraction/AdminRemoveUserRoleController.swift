import FeatherAdmin
import Hummingbird

protocol AdminRemoveUserRoleController: Sendable {

    func getRemoveUserRole(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postRemoveUserRole(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func getRemoveUserRoles(request: Request, context: DefaultRequestContext)
        async throws -> Response
    func postRemoveUserRoles(request: Request, context: DefaultRequestContext)
        async throws -> Response
}

extension AdminRemoveUserRoleController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            RouterPath(UserRoleRoutes.removePattern.description + "/"),
            use: getRemoveUserRole
        )
        router.post(
            RouterPath(UserRoleRoutes.removePattern.description + "/"),
            use: postRemoveUserRole
        )
        router.get(
            RouterPath(UserRoleRoutes.remove.description + "/"),
            use: getRemoveUserRoles
        )
        router.post(
            RouterPath(UserRoleRoutes.remove.description + "/"),
            use: postRemoveUserRoles
        )
    }
}
