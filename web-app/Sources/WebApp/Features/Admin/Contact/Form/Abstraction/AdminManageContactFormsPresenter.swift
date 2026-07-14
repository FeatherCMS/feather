import Hummingbird

protocol AdminManageContactFormsPresenter: Sendable {
    func renderList(items: [AdminManageContactFormItem], search: String, isAdded: Bool, isEdited: Bool, isRemoved: Bool, error: String?, permissions: Set<String>) -> HTMLResponse
    func renderEdit(item: AdminManageContactFormItem, error: String?, permissions: Set<String>) -> HTMLResponse
    func renderEmails(item: AdminManageContactFormItem, error: String?, permissions: Set<String>) -> HTMLResponse
    func renderEmailAdd(formId: String, error: String?, permissions: Set<String>) -> HTMLResponse
    func renderEmailEdit(formId: String, mail: AdminManageContactFormMail, error: String?, permissions: Set<String>) -> HTMLResponse
    func renderEmailRemove(formId: String, mail: AdminManageContactFormMail, permissions: Set<String>) -> HTMLResponse
    func renderRemoveConfirmation(id: String, name: String, permissions: Set<String>) -> HTMLResponse
    func renderBulkRemoveConfirmation(selectedIds: [String], permissions: Set<String>) -> HTMLResponse
}
