import Hummingbird

protocol AdminRemoveContactFormSubmissionsController: Sendable {
    func confirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
    func bulkConfirm(request: Request, context: AppRequestContext) async throws -> HTMLResponse
    func bulkRemove(request: Request, context: AppRequestContext) async throws -> Response
}

extension AdminRemoveContactFormSubmissionsController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/contact/forms/:formId/submissions/:submissionId/remove/",
            use: confirm
        )
        router.post(
            "/admin/contact/forms/:formId/submissions/:submissionId/remove/",
            use: remove
        )
        router.get("/admin/contact/forms/:formId/submissions/remove/", use: bulkConfirm)
        router.post("/admin/contact/forms/:formId/submissions/remove/", use: bulkRemove)
    }
}
