import Hummingbird

protocol AdminNewsletterSubscribersDirectoryController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func bulkRemoveConfirmation(request: Request, context: AppRequestContext) async throws -> Response
    func bulkRemove(request: Request, context: AppRequestContext) async throws -> Response
}

extension AdminNewsletterSubscribersDirectoryController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/subscribers/", use: list)
        router.get("/admin/newsletters/subscribers/bulk-remove/", use: bulkRemoveConfirmation)
        router.post("/admin/newsletters/subscribers/bulk-remove/", use: bulkRemove)
    }
}
