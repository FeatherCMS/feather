import Hummingbird

protocol AdminRemoveUserRoleController: Sendable {

    func getRemoveUserRole(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveUserRole(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveUserRoleController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/roles/{id}/remove/",
            use: getRemoveUserRole
        )
        router.post(
            "/admin/user/roles/{id}/remove/",
            use: postRemoveUserRole
        )
    }
}
