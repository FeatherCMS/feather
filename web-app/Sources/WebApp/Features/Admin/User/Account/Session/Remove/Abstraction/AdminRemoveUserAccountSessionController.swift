import Hummingbird

protocol AdminRemoveUserAccountSessionController: Sendable {

    func getRemoveUserAccountSession(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveUserAccountSession(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveUserAccountSessionController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/user/accounts/{id}/sessions/{sessionId}/remove/",
            use: getRemoveUserAccountSession
        )
        router.post(
            "/admin/user/accounts/{id}/sessions/{sessionId}/remove/",
            use: postRemoveUserAccountSession
        )
    }
}
