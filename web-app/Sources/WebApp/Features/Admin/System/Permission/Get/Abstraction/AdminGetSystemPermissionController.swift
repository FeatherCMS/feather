import Hummingbird

protocol AdminGetSystemPermissionController: Sendable {

    func getSystemPermission(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetSystemPermissionController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/system/permissions/{id}/",
            use: getSystemPermission
        )
    }
}
