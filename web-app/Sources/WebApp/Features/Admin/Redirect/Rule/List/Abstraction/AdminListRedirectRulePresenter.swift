import Hummingbird

protocol AdminListRedirectRulePresenter: Sendable {

    func renderListPage(
        model: AdminListRedirectRuleModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        statusCode: String?,
        error: String?
    ) -> HTMLResponse

    func renderBulkRemoveConfirmation(
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse
}
