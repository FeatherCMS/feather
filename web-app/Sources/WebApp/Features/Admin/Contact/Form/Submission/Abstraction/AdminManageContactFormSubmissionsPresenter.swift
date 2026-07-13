import Hummingbird

protocol AdminManageContactFormSubmissionsPresenter: Sendable {
    func renderList(formId: String, items: [AdminManageContactFormSubmissionRow], error: String?, permissions: Set<String>) -> HTMLResponse
    func renderDetail(formId: String, item: AdminManageContactFormSubmissionRow, error: String?, permissions: Set<String>) -> HTMLResponse
}
