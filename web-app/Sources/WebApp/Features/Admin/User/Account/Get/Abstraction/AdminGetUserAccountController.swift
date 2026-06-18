import Hummingbird

protocol AdminGetUserAccountController: Sendable {

    func getUserAccount(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func getUserAccountSessionsBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postUserAccountSessionsBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminGetUserAccountController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/accounts/{id}/",
            use: getUserAccount
        )
        router.get(
            "/admin/user/accounts/{id}/sessions/bulk-remove/",
            use: getUserAccountSessionsBulkRemoveConfirmation
        )
        router.post(
            "/admin/user/accounts/{id}/sessions/bulk-remove/",
            use: postUserAccountSessionsBulkRemove
        )
    }
}
