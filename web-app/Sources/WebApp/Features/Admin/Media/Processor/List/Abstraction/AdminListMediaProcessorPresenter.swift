import AdminOpenAPI
import Hummingbird

protocol AdminListMediaProcessorPresenter: Sendable {

    func renderListPage(
        items: [Components.Schemas.MediaProcessorListItemSchema],
        page: Int,
        pageSize: Int,
        total: Int,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        error: String?
    ) -> HTMLResponse

    func renderBulkRemoveConfirmation(
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse
}
