import Hummingbird

protocol AdminManageNewsletterSubscribersController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func add(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func create(request: Request, context: AppRequestContext) async throws -> Response
    func edit(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws -> Response
    func confirmRemove(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func remove(request: Request, context: AppRequestContext) async throws -> Response
    func confirmBulkRemove(request: Request, context: AppRequestContext) async throws -> Response
    func bulkRemove(request: Request, context: AppRequestContext) async throws -> Response
}

extension AdminManageNewsletterSubscribersController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/:newsletterId/subscribers/", use: list)
        router.get("/admin/newsletters/:newsletterId/subscribers/add/", use: add)
        router.post("/admin/newsletters/:newsletterId/subscribers/add/", use: create)
        router.get("/admin/newsletters/:newsletterId/subscribers/:subscriberId/edit/", use: edit)
        router.post("/admin/newsletters/:newsletterId/subscribers/:subscriberId/edit/", use: update)
        router.get("/admin/newsletters/:newsletterId/subscribers/:subscriberId/remove/", use: confirmRemove)
        router.post("/admin/newsletters/:newsletterId/subscribers/:subscriberId/remove/", use: remove)
        router.get("/admin/newsletters/:newsletterId/subscribers/bulk-remove/", use: confirmBulkRemove)
        router.post("/admin/newsletters/:newsletterId/subscribers/bulk-remove/", use: bulkRemove)
    }
}
