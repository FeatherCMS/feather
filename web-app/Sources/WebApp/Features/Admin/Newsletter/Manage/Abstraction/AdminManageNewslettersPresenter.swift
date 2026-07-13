import Hummingbird

protocol AdminManageNewslettersPresenter: Sendable {
    func renderList(items: [AdminManageNewsletterItem], isAdded: Bool, isEdited: Bool, isRemoved: Bool, error: String?, permissions: Set<String>) -> HTMLResponse
    func renderEdit(item: AdminManageNewsletterItem, error: String?, permissions: Set<String>) -> HTMLResponse
}
