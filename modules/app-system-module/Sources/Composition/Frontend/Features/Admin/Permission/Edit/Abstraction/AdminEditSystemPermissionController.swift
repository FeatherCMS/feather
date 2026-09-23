import FeatherAdmin
import Hummingbird

protocol AdminEditSystemPermissionController: Sendable {

    func getEditSystemPermission(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditSystemPermission(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditSystemPermissionController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            SystemPermissionRoutes.edit(RouterPath("{id}")),
            use: getEditSystemPermission
        )
        router.post(
            SystemPermissionRoutes.edit(RouterPath("{id}")),
            use: postEditSystemPermission
        )
    }
}
