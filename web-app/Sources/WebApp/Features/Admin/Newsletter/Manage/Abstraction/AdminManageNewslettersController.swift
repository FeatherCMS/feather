import Hummingbird

protocol AdminManageNewslettersController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func edit(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws -> Response
    func remove(request: Request, context: AppRequestContext) async throws -> Response
}

extension AdminManageNewslettersController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/", use: list)
        router.get("/admin/newsletters/:id/details/", use: edit)
        router.get("/admin/newsletters/:id/edit/", use: edit)
        router.post("/admin/newsletters/:id/edit/", use: update)
        router.post("/admin/newsletters/:id/remove/", use: remove)
    }
}
