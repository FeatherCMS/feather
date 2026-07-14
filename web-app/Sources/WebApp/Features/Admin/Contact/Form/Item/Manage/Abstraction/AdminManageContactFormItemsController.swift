import Hummingbird

protocol AdminManageContactFormItemsController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func edit(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws -> Response
    func confirmRemove(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func remove(request: Request, context: AppRequestContext) async throws -> Response
    func bulkRemoveConfirmation(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func bulkRemove(request: Request, context: AppRequestContext) async throws -> Response
}

extension AdminManageContactFormItemsController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/:formId/items/", use: list)
        router.get("/admin/contact/fields/", use: list)
        router.get("/admin/contact/forms/:formId/items/:itemId/edit/", use: edit)
        router.get("/admin/contact/fields/:itemId/edit/", use: edit)
        router.post("/admin/contact/forms/:formId/items/:itemId/edit/", use: update)
        router.post("/admin/contact/fields/:itemId/edit/", use: update)
        router.get("/admin/contact/forms/:formId/items/:itemId/remove/", use: confirmRemove)
        router.get("/admin/contact/fields/:itemId/remove/", use: confirmRemove)
        router.post("/admin/contact/forms/:formId/items/:itemId/remove/", use: remove)
        router.post("/admin/contact/fields/:itemId/remove/", use: remove)
        router.get("/admin/contact/forms/:formId/items/bulk-remove/", use: bulkRemoveConfirmation)
        router.get("/admin/contact/fields/bulk-remove/", use: bulkRemoveConfirmation)
        router.post("/admin/contact/forms/:formId/items/bulk-remove/", use: bulkRemove)
        router.post("/admin/contact/fields/bulk-remove/", use: bulkRemove)
    }
}
