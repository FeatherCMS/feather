import Hummingbird

protocol AdminManageContactFormsController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func add(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func create(request: Request, context: AppRequestContext) async throws -> Response
    func edit(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func emails(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func updateEmails(request: Request, context: AppRequestContext) async throws -> Response
    func addEmail(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func createEmail(request: Request, context: AppRequestContext) async throws -> Response
    func editEmail(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func updateEmail(request: Request, context: AppRequestContext) async throws -> Response
    func confirmRemoveEmail(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func removeEmail(request: Request, context: AppRequestContext) async throws -> Response
    func confirmRemove(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws -> Response
    func remove(request: Request, context: AppRequestContext) async throws -> Response
    func bulkRemoveConfirmation(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func bulkRemove(request: Request, context: AppRequestContext) async throws -> Response
}

extension AdminManageContactFormsController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/", use: list)
        router.get("/admin/contact/forms/add/", use: add)
        router.post("/admin/contact/forms/add/", use: create)
        router.get("/admin/contact/forms/:id/edit/", use: edit)
        router.post("/admin/contact/forms/:id/edit/", use: update)
        router.get("/admin/contact/forms/:id/details/", use: edit)
        router.get("/admin/contact/forms/:id/emails/", use: emails)
        router.post("/admin/contact/forms/:id/emails/", use: updateEmails)
        router.get("/admin/contact/forms/:id/emails/add/", use: addEmail)
        router.post("/admin/contact/forms/:id/emails/add/", use: createEmail)
        router.get("/admin/contact/forms/:id/emails/:mailId/edit/", use: editEmail)
        router.post("/admin/contact/forms/:id/emails/:mailId/edit/", use: updateEmail)
        router.get("/admin/contact/forms/:id/emails/:mailId/remove/", use: confirmRemoveEmail)
        router.post("/admin/contact/forms/:id/emails/:mailId/remove/", use: removeEmail)
        router.get("/admin/contact/forms/:id/remove/", use: confirmRemove)
        router.post("/admin/contact/forms/:id/remove/", use: remove)
        router.get("/admin/contact/forms/bulk-remove/", use: bulkRemoveConfirmation)
        router.post("/admin/contact/forms/bulk-remove/", use: bulkRemove)
    }
}
