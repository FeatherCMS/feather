import FeatherAdmin
import Hummingbird

protocol AdminEditSystemPermissionController: Sendable {

    func getEditSystemPermission(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditSystemPermission(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditSystemPermissionController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(SystemPermissionRoutes.edit(RouterPath("{id}")), use: getEditSystemPermission)
        router.post(SystemPermissionRoutes.edit(RouterPath("{id}")), use: postEditSystemPermission)
    }
}
