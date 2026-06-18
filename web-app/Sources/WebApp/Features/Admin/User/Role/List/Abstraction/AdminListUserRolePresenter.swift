import Foundation
import Hummingbird

protocol AdminListUserRolePresenter: Sendable {

    func renderListPage(
        model: AdminListUserRoleModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) -> HTMLResponse

    func renderBulkRemoveConfirmation(
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse

    func errorState(
        error: OpenAPIRepositoryError
    ) -> UserRoleError.State
}
