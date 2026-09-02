import FeatherAdmin
import Hummingbird
import SystemContracts

protocol AdminListSystemPermissionController: Sendable {

    func getSystemPermissions(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getSystemPermissionsRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postSystemPermissionsRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListSystemPermissionController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/system/permissions",
            use: getSystemPermissions
        )
        router.get(
            "/admin/system/permissions/remove/",
            use: getSystemPermissionsRemoveConfirmation
        )
        router.post(
            "/admin/system/permissions/remove/",
            use: postSystemPermissionsRemove
        )
    }
}
