import Hummingbird

protocol AdminEditContactFormSubmissionPresenter: Sendable {
    func renderError(
        formId: String,
        id: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse
}
