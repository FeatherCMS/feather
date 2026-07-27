import Hummingbird

protocol AdminManageNewslettersController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func bulkRemoveConfirmation(request: Request, context: AppRequestContext)
        async throws -> HTMLResponse
    func bulkRemove(request: Request, context: AppRequestContext) async throws
        -> Response
    func edit(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws
        -> Response
    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminManageNewslettersController {
    func routeList(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/", use: list)
    }

    func routeBulkRemove(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/newsletters/bulk-remove/",
            use: bulkRemoveConfirmation
        )
        router.post("/admin/newsletters/bulk-remove/", use: bulkRemove)
    }

    func routeEdit(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/:newsletterId/details/", use: edit)
        router.get("/admin/newsletters/:newsletterId/edit/", use: edit)
        router.post("/admin/newsletters/:newsletterId/edit/", use: update)
    }

    func routeRemove(on router: Router<AppRequestContext>) {
        router.post("/admin/newsletters/:newsletterId/remove/", use: remove)
    }
}
