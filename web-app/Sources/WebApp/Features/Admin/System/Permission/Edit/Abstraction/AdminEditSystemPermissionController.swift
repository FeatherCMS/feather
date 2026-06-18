import Hummingbird

protocol AdminEditSystemPermissionController: Sendable {

    func getEditSystemPermission(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditSystemPermission(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditSystemPermissionController {

    func route(
        on router: Router<AppRequestContext>
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
