import FeatherAdmin
import Hummingbird

protocol AdminRemoveUserRoleController: Sendable {

    func getRemoveUserRole(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postRemoveUserRole(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func getRemoveUserRoles(request: Request, context: AuthenticatedRequestContext)
        async throws -> Response
    func postRemoveUserRoles(request: Request, context: AuthenticatedRequestContext)
        async throws -> Response
}

extension AdminRemoveUserRoleController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            UserRoleRoutes.remove(RouterPath("{id}")),
            use: getRemoveUserRole
        )
        router.post(
            UserRoleRoutes.remove(RouterPath("{id}")),
            use: postRemoveUserRole
        )
        router.get(
            UserRoleRoutes.remove,
            use: getRemoveUserRoles
        )
        router.post(
            UserRoleRoutes.remove,
            use: postRemoveUserRoles
        )
    }
}
