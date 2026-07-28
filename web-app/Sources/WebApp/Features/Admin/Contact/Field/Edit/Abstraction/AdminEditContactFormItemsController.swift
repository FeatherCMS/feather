import Hummingbird

protocol AdminEditContactFormItemsController: Sendable {
    func edit(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminEditContactFormItemsController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/contact/forms/:formId/items/:itemId/edit/",
            use: edit
        )
        router.post(
            "/admin/contact/forms/:formId/items/:itemId/edit/",
            use: update
        )
    }
}
