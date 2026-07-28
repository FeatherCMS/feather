import Hummingbird

protocol AppContactFormSubmissionController: Sendable {

    func submit(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AppContactFormSubmissionController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.post(
            "/contact/forms/:formId/submissions",
            use: submit
        )
    }
}
