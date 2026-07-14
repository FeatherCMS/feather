import Hummingbird

protocol AdminManageNewslettersController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func bulkRemoveConfirmation(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func bulkRemove(request: Request, context: AppRequestContext) async throws -> Response
    func edit(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws -> Response
    func remove(request: Request, context: AppRequestContext) async throws -> Response
}

extension AdminManageNewslettersController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/", use: list)
        router.get("/admin/newsletters/bulk-remove/", use: bulkRemoveConfirmation)
        router.post("/admin/newsletters/bulk-remove/", use: bulkRemove)
        router.get("/admin/newsletters/:id/details/", use: edit)
        router.get("/admin/newsletters/:id/edit/", use: edit)
        router.post("/admin/newsletters/:id/edit/", use: update)
        router.post("/admin/newsletters/:id/remove/", use: remove)
    }
}
