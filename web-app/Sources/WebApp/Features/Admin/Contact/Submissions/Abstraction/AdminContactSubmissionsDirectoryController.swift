import Hummingbird

protocol AdminContactSubmissionsDirectoryController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func bulkRemoveConfirmation(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func bulkRemove(request: Request, context: AppRequestContext) async throws -> Response
}

extension AdminContactSubmissionsDirectoryController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/submissions/", use: list)
        router.get("/admin/contact/submissions/bulk-remove/", use: bulkRemoveConfirmation)
        router.post("/admin/contact/submissions/bulk-remove/", use: bulkRemove)
    }
}
