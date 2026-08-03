import Hummingbird

protocol AdminListAuthCredentialController: Sendable {
    func getCredentials(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListAuthCredentialController {
    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/auth/credentials/{id}",
            use: getCredentials
        )
    }
}
