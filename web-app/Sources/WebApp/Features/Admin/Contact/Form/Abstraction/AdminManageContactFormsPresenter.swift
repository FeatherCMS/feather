import Hummingbird

protocol AdminManageContactFormsPresenter: Sendable {
    func renderList(items: [AdminManageContactFormItem], isAdded: Bool, isEdited: Bool, isRemoved: Bool, error: String?, permissions: Set<String>) -> HTMLResponse
    func renderEdit(item: AdminManageContactFormItem, error: String?, permissions: Set<String>) -> HTMLResponse
}
