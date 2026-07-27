import Hummingbird

protocol AdminListContactFormSubmissionsPresenter: Sendable {
    func renderList(
        formId: String,
        items: [AdminContactFormSubmissionItem],
        search: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
