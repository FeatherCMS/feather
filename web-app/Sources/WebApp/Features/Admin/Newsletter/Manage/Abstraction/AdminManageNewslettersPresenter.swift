import Hummingbird

protocol AdminManageNewslettersPresenter: Sendable {
    func renderList(items: [AdminManageNewsletterItem], isAdded: Bool, isEdited: Bool, isRemoved: Bool, isPicker: Bool, error: String?, permissions: Set<String>, search: String) -> HTMLResponse
    func renderBulkRemoveConfirmation(page: Int, search: String, selectedIds: [String], permissions: Set<String>) -> HTMLResponse
    func renderEdit(item: AdminManageNewsletterItem, error: String?, permissions: Set<String>) -> HTMLResponse
}
