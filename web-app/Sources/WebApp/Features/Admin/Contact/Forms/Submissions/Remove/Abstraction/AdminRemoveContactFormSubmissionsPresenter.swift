import Hummingbird

protocol AdminRemoveContactFormSubmissionsPresenter: Sendable {
    func renderConfirmation(
        formId: String,
        item: AdminContactFormSubmissionItem,
        permissions: Set<String>
    ) -> HTMLResponse
    func renderBulkConfirmation(formId: String, selectedIds: [String], permissions: Set<String>) -> HTMLResponse
}
