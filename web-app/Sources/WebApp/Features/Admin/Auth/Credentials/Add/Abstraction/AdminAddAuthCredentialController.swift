import Hummingbird

protocol AdminAddAuthCredentialController: Sendable {
    func getAddCredential(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func postAddCredential(request: Request, context: AppRequestContext) async throws -> Response
}

extension AdminAddAuthCredentialController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/auth/credentials/{id}/add", use: getAddCredential)
        router.post("/admin/auth/credentials/{id}/add", use: postAddCredential)
    }
}
