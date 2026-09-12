import FeatherAdmin
import Hummingbird

protocol AdminGetSystemPermissionController: Sendable {

    func getSystemPermission(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetSystemPermissionController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            SystemPermissionRoutes.details(RouterPath("{id}")),
            use: getSystemPermission
        )
    }
}
