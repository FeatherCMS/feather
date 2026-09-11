import FeatherAdmin
import Hummingbird
import SystemAdminAPI

protocol AdminListSystemVariablePresenter: Sendable {

    func renderListPage(
        model: AdminListModel<Components.Schemas.SystemVariableListItemSchema>,
        notification: AdminNotification?,
        permissions: Set<String>,
        search: String?
    ) async throws -> HTMLResponse

    func renderErrorPage(
        title: String,
        message: String,
        notification: AdminNotification?
    ) async throws -> HTMLResponse

}
