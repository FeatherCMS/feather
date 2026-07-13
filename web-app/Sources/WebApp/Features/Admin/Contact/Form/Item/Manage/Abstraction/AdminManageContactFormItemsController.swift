import Hummingbird

protocol AdminManageContactFormItemsController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func edit(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws -> Response
    func confirmRemove(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func remove(request: Request, context: AppRequestContext) async throws -> Response
}

extension AdminManageContactFormItemsController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/:formId/items/", use: list)
        router.get("/admin/contact/forms/:formId/items/:itemId/edit/", use: edit)
        router.post("/admin/contact/forms/:formId/items/:itemId/edit/", use: update)
        router.get("/admin/contact/forms/:formId/items/:itemId/remove/", use: confirmRemove)
        router.post("/admin/contact/forms/:formId/items/:itemId/remove/", use: remove)
    }
}
