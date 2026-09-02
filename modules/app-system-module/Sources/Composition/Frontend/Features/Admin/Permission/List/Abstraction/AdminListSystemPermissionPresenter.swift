import FeatherAdmin
import Hummingbird

protocol AdminListSystemPermissionPresenter: Sendable {

    func renderListPage(
        model: AdminListSystemPermissionModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) -> HTMLResponse

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse
}
