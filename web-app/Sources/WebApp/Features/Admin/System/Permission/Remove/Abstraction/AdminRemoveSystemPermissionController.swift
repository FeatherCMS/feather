import Hummingbird

protocol AdminRemoveSystemPermissionController: Sendable {

    func getRemoveSystemPermission(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveSystemPermission(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveSystemPermissionController {

    func route(
        on router: Router<AppRequestContext>
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
