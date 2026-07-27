import Hummingbird

protocol AdminEditContactFormSubmissionController: Sendable {
    func update(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminEditContactFormSubmissionController {
    func route(on router: Router<AppRequestContext>) {
        router.post(
            "/admin/contact/forms/:formId/submissions/:submissionId/",
            use: update
        )
    }
}
