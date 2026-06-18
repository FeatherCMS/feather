import Hummingbird

protocol AdminListUserAccountController: Sendable {

    func getUserAccounts(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func getUserAccountsBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postUserAccountsBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminListUserAccountController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/accounts",
            use: getUserAccounts
        )
        router.get(
            "/admin/user/accounts/bulk-remove/",
            use: getUserAccountsBulkRemoveConfirmation
        )
        router.post(
            "/admin/user/accounts/bulk-remove/",
            use: postUserAccountsBulkRemove
        )
    }
}
