import FeatherAdmin
import Hummingbird

protocol AdminRemoveSystemPermissionController: Sendable {

    func getRemoveSystemPermissions(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postRemoveSystemPermissions(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveSystemPermissionController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            SystemPermissionRoutes.remove,
            use: getRemoveSystemPermissions
        )
        router.post(
            SystemPermissionRoutes.remove,
            use: postRemoveSystemPermissions
        )
    }
}
