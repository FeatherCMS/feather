import Hummingbird

protocol AdminAddSystemPermissionController: Sendable {

    func getAddSystemPermission(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddSystemPermission(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddSystemPermissionController {

    func route(
        on router: Router<AppRequestContext>
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
