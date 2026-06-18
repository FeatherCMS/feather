import Hummingbird

protocol AdminListSystemPermissionController: Sendable {

    func getSystemPermissions(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func getSystemPermissionsBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postSystemPermissionsBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminListSystemPermissionController {

    func route(
        on router: Router<AppRequestContext>
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
