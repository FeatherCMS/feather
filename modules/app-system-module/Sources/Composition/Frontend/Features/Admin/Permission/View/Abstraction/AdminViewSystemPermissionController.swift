import FeatherAdmin
import Hummingbird

protocol AdminViewSystemPermissionController: Sendable {

    func getSystemPermission(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewSystemPermissionController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            SystemPermissionRoutes.details(RouterPath("{id}")),
            use: getSystemPermission
        )
    }
}
