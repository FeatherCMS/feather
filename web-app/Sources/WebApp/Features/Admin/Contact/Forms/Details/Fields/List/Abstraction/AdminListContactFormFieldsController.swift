import Hummingbird

protocol AdminListContactFormFieldsController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminListContactFormFieldsController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/:formId/items/", use: list)
    }
}
