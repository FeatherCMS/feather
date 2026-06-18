import Hummingbird

protocol AdminListMediaAssetPresenter: Sendable {

    func renderListPage(
        model: AdminListMediaAssetModel,
        page: Int,
        search: String?,
        parentId: String?,
        view: AdminListMediaAssetModel.ViewMode,
        isAdded: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        error: String?
    ) -> HTMLResponse

    func renderBulkRemoveConfirmation(
        page: Int,
        search: String?,
        parentId: String?,
        view: AdminListMediaAssetModel.ViewMode,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse
}
