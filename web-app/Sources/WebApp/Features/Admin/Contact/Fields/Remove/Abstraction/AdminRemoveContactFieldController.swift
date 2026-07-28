import Hummingbird

protocol AdminRemoveContactFieldController: Sendable {
    func confirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
    func bulkConfirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func bulkRemove(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminRemoveContactFieldController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/fields/:fieldId/remove/", use: confirm)
        router.post("/admin/contact/fields/:fieldId/remove/", use: remove)
        router.get("/admin/contact/fields/remove/", use: bulkConfirm)
        router.post("/admin/contact/fields/remove/", use: bulkRemove)
    }
}
