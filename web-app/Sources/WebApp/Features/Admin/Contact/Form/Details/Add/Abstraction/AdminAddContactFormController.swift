import Hummingbird

protocol AdminAddContactFormController: Sendable {
    func add(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func create(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminAddContactFormController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/add/", use: add)
        router.post("/admin/contact/forms/add/", use: create)
    }
}
