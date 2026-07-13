import Hummingbird

protocol AdminManageContactFormsController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func add(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func create(request: Request, context: AppRequestContext) async throws -> Response
    func edit(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws -> Response
    func remove(request: Request, context: AppRequestContext) async throws -> Response
}

extension AdminManageContactFormsController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/", use: list)
        router.get("/admin/contact/forms/add/", use: add)
        router.post("/admin/contact/forms/add/", use: create)
        router.get("/admin/contact/forms/:id/edit/", use: edit)
        router.post("/admin/contact/forms/:id/edit/", use: update)
        router.post("/admin/contact/forms/:id/remove/", use: remove)
    }
}
