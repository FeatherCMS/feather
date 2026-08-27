import FeatherAdmin
import Hummingbird

protocol AdminAddSystemPermissionController: Sendable {

    func getAddSystemPermission(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddSystemPermission(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddSystemPermissionController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/system/permissions/add/",
            use: getAddSystemPermission
        )
        router.post(
            "/admin/system/permissions/add/",
            use: postAddSystemPermission
        )
    }
}
