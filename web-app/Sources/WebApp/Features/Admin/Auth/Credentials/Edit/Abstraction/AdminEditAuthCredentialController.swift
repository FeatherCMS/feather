import Hummingbird

protocol AdminEditAuthCredentialController: Sendable {
    func getEditCredential(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func postEditCredential(request: Request, context: AppRequestContext) async throws -> Response
}

extension AdminEditAuthCredentialController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/auth/credentials/{id}/edit", use: getEditCredential)
        router.post("/admin/auth/credentials/{id}/edit", use: postEditCredential)
    }
}
