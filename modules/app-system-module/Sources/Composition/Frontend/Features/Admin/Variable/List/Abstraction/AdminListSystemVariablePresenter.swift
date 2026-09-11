import SystemAdminAPI
import FeatherAdmin
import Hummingbird

protocol AdminListSystemVariablePresenter: Sendable {

    func renderListPage(
        model: AdminListModel<Components.Schemas.SystemVariableListItemSchema>,
        notification: AdminNotification?,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse

}
