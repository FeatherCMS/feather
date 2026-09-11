import FeatherAdmin
import FeatherContracts
import Hummingbird
import SystemAdminAPI

protocol AdminListSystemVariablePresenter: Sendable {

    func renderListPage(
        model: AdminListModel<Components.Schemas.SystemVariableListItemSchema>,
        permissions: Set<PermissionKey>,
        search: String?
    ) async throws -> HTMLResponse

    func renderErrorPage(
        title: String,
        message: String
    ) async throws -> HTMLResponse

}
