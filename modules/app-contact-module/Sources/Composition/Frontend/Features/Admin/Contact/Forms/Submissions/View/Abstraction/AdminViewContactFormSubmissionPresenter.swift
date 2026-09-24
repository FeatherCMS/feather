import FeatherAdmin

protocol AdminViewContactFormSubmissionPresenter: Sendable {
    func renderDetailsPage(
        formId: String,
        item: AdminContactFormSubmissionItem,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
