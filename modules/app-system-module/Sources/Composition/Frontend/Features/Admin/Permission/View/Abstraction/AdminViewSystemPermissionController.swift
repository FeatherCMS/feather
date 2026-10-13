import FeatherAdmin
import Hummingbird

protocol AdminViewSystemPermissionController: Sendable {

    func getSystemPermission(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewSystemPermissionController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            SystemPermissionRoutes.details(RouterPath("{id}")),
            use: getSystemPermission
        )
    }
}
