import FeatherAdmin
import Hummingbird

protocol AdminRemoveUserRoleController: Sendable {

    func postRemoveUserRole(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postRemoveUserRoles(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> Response
}

extension AdminRemoveUserRoleController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.post(
            UserRoleRoutes.remove,
            use: postRemoveUserRoles
        )
    }
}
