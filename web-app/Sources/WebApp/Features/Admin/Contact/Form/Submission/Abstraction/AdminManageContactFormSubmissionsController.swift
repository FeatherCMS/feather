import Hummingbird

protocol AdminManageContactFormSubmissionsController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func get(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws -> Response
}

extension AdminManageContactFormSubmissionsController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/contact/forms/:formId/submissions/", use: list)
        router.get("/admin/contact/forms/:formId/submissions/:submissionId/", use: get)
        router.post("/admin/contact/forms/:formId/submissions/:submissionId/", use: update)
    }
}
