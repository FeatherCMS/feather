import FeatherAdmin
import Hummingbird

protocol AdminAddSystemPermissionController: Sendable {

    func getAddSystemPermission(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddSystemPermission(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddSystemPermissionController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(SystemPermissionRoutes.add, use: getAddSystemPermission)
        router.post(SystemPermissionRoutes.add, use: postAddSystemPermission)
    }
}
