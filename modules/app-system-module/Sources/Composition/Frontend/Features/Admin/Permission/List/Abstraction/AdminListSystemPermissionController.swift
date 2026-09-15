import FeatherAdmin
import Hummingbird
import SystemContracts

protocol AdminListSystemPermissionController: Sendable {

    func getSystemPermissions(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

}

extension AdminListSystemPermissionController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(SystemPermissionRoutes.list, use: getSystemPermissions)
    }
}
