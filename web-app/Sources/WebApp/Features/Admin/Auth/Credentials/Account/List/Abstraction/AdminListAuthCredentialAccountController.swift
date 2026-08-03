import Hummingbird

protocol AdminListAuthCredentialAccountController: Sendable {
    func getAccounts(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListAuthCredentialAccountController {
    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get("/admin/auth/credentials", use: getAccounts)
    }
}
