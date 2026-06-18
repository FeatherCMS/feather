import Hummingbird

protocol AdminGetUserRoleController: Sendable {

    func getUserRole(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetUserRoleController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/roles/{id}/",
            use: getUserRole
        )
    }
}
