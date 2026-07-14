import Hummingbird

protocol AdminManageContactFormItemsPresenter: Sendable {
    func renderList(formId: String, items: [AdminManageContactFormItemRow], search: String, error: String?, permissions: Set<String>) -> HTMLResponse
    func renderBulkRemoveConfirmation(formId: String, selectedIds: [String], permissions: Set<String>) -> HTMLResponse
    func renderEdit(formId: String, item: AdminManageContactFormItemRow, error: String?, permissions: Set<String>) -> HTMLResponse
    func renderRemoveConfirmation(formId: String, itemId: String, label: String, permissions: Set<String>) -> HTMLResponse
}
