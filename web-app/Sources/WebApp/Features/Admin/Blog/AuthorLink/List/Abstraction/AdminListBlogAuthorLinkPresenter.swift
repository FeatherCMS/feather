import Hummingbird

protocol AdminListBlogAuthorLinkPresenter: Sendable {

    func renderListPage(
        menuId: String,
        model: AdminListBlogAuthorLinkModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) -> HTMLResponse

    func renderBulkRemoveConfirmation(
        menuId: String,
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse
}
