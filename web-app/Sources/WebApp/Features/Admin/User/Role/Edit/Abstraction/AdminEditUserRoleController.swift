import Hummingbird

protocol AdminEditUserRoleController: Sendable {

    func getEditUserRole(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditUserRole(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditUserRoleController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/roles/{id}/edit/",
            use: getEditUserRole
        )
        router.post(
            "/admin/user/roles/{id}/edit/",
            use: postEditUserRole
        )
    }
}
