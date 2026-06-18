import Hummingbird

protocol AdminEditUserAccountController: Sendable {

    func getEditUserAccount(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditUserAccount(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditUserAccountController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/accounts/{id}/edit/",
            use: getEditUserAccount
        )
        router.post(
            "/admin/user/accounts/{id}/edit/",
            use: postEditUserAccount
        )
    }
}
