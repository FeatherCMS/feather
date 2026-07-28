import Hummingbird

protocol AdminEditContactFormController: Sendable {
    func edit(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminEditContactFormController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/:formId/edit/", use: edit)
        router.post("/admin/contact/forms/:formId/edit/", use: update)
    }
}
