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
        router.get(
            "/admin/system/permissions/{id}/edit/",
            use: getEditSystemPermission
        )
        router.post(
            "/admin/system/permissions/{id}/edit/",
            use: postEditSystemPermission
        )
    }
}
