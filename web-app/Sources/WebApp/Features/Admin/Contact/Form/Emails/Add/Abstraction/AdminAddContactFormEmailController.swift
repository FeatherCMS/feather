import Hummingbird

protocol AdminAddContactFormEmailController: Sendable {
    func add(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func create(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminAddContactFormEmailController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/:formId/emails/add/", use: add)
        router.post("/admin/contact/forms/:formId/emails/add/", use: create)
    }
}
