import Hummingbird

protocol AdminGetContactFormSubmissionPresenter: Sendable {
    func renderPage(
        formId: String,
        item: AdminContactFormSubmissionItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
