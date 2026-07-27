import Hummingbird

protocol AdminRemoveContactFormItemsController: Sendable {
    func confirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
    func bulkConfirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func bulkRemove(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminRemoveContactFormItemsController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/contact/forms/:formId/items/:itemId/remove/",
            use: confirm
        )
        router.get("/admin/contact/fields/:itemId/remove/", use: confirm)
        router.post(
            "/admin/contact/forms/:formId/items/:itemId/remove/",
            use: remove
        )
        router.post("/admin/contact/fields/:itemId/remove/", use: remove)
        router.get(
            "/admin/contact/forms/:formId/items/bulk-remove/",
            use: bulkConfirm
        )
        router.get("/admin/contact/fields/bulk-remove/", use: bulkConfirm)
        router.post(
            "/admin/contact/forms/:formId/items/bulk-remove/",
            use: bulkRemove
        )
        router.post("/admin/contact/fields/bulk-remove/", use: bulkRemove)
    }
}
