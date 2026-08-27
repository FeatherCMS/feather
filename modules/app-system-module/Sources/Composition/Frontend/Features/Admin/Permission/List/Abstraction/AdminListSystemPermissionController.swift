import FeatherAdmin
import Hummingbird
import SystemContracts

protocol AdminListSystemPermissionController: Sendable {

    func getSystemPermissions(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getSystemPermissionsBulkRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postSystemPermissionsBulkRemove(
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
            "/admin/system/permissions/bulk-remove/",
            use: getSystemPermissionsBulkRemoveConfirmation
        )
        router.post(
            "/admin/system/permissions/bulk-remove/",
            use: postSystemPermissionsBulkRemove
        )
    }
}
