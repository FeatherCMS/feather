import FeatherAdmin
import Hummingbird
import SystemAdminAPI

protocol AdminListSystemVariablePresenter: Sendable {

    func renderListPage(
        model: AdminListModel<Components.Schemas.SystemVariableListItemSchema>?,
        notification: AdminNotification?,
        permissions: Set<String>,
        search: String?,
        error: String?,
        accessDenied: Bool
    ) async throws -> HTMLResponse

}
