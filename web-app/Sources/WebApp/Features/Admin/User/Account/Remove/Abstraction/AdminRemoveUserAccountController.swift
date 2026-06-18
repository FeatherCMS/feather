import Hummingbird

protocol AdminRemoveUserAccountController: Sendable {

    func getRemoveUserAccount(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveUserAccount(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveUserAccountController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/accounts/{id}/remove/",
            use: getRemoveUserAccount
        )
        router.post(
            "/admin/user/accounts/{id}/remove/",
            use: postRemoveUserAccount
        )
    }
}
