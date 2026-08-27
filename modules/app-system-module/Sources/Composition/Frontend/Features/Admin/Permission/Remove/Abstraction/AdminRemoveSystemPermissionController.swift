import FeatherAdmin
import Hummingbird

protocol AdminRemoveSystemPermissionController: Sendable {

    func getRemoveSystemPermission(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postRemoveSystemPermission(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveSystemPermissionController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/system/permissions/{id}/remove/",
            use: getRemoveSystemPermission
        )
        router.post(
            "/admin/system/permissions/{id}/remove/",
            use: postRemoveSystemPermission
        )
    }
}
