import FeatherAdmin
import Hummingbird
import SystemContracts

protocol AdminListSystemPermissionController: Sendable {

    func getSystemPermissions(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

}

extension AdminListSystemPermissionController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(SystemPermissionRoutes.list, use: getSystemPermissions)
    }
}
