import Hummingbird

protocol AdminGetContactFormSubmissionController: Sendable {
    func get(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminGetContactFormSubmissionController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/contact/forms/:formId/submissions/:submissionId/",
            use: get
        )
    }
}
