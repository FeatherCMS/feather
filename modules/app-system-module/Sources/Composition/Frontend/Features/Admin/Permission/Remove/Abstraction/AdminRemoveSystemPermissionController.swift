import SystemModule
import FeatherAdmin
import Hummingbird

protocol AdminRemoveSystemPermissionController: Sendable {

    func postRemoveSystemPermissions(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveSystemPermissionController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.post(
            SystemPermissionRoutes.remove,
            use: postRemoveSystemPermissions
        )
    }
}
