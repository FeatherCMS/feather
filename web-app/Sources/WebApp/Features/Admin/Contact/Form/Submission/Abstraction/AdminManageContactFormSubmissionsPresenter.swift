import Hummingbird

protocol AdminManageContactFormSubmissionsPresenter: Sendable {
    func renderList(formId: String, items: [AdminManageContactFormSubmissionRow], search: String, error: String?, permissions: Set<String>) -> HTMLResponse
    func renderDetail(formId: String, item: AdminManageContactFormSubmissionRow, error: String?, permissions: Set<String>) -> HTMLResponse
    func renderRemoveConfirmation(formId: String, item: AdminManageContactFormSubmissionRow, permissions: Set<String>) -> HTMLResponse
    func renderBulkRemoveConfirmation(formId: String, selectedIds: [String], permissions: Set<String>) -> HTMLResponse
}
