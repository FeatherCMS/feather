import Hummingbird

protocol AdminManageContactFormItemsPresenter: Sendable {
    func renderList(formId: String, items: [AdminManageContactFormItemRow], error: String?, permissions: Set<String>) -> HTMLResponse
    func renderEdit(formId: String, item: AdminManageContactFormItemRow, error: String?, permissions: Set<String>) -> HTMLResponse
    func renderRemoveConfirmation(formId: String, itemId: String, label: String, permissions: Set<String>) -> HTMLResponse
}
