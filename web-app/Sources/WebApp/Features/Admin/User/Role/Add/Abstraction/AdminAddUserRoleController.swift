import Hummingbird

protocol AdminAddUserRoleController: Sendable {

    func getAddUserRole(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddUserRole(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddUserRoleController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/roles/add/",
            use: getAddUserRole
        )
        router.post(
            "/admin/user/roles/add/",
            use: postAddUserRole
        )
    }
}
