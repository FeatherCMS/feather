import Hummingbird

protocol AdminListContactFormItemsController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactFormItemsController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/:formId/items/", use: list)
    }
    func routeGlobal(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/fields/", use: list)
    }
}
