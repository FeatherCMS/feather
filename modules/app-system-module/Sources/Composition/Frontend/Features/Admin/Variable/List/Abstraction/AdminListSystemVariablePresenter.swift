import FeatherAdmin
import Hummingbird
import SystemAdminAPI

protocol AdminListSystemVariablePresenter: Sendable {

    func renderListPage(
        model: AdminListModel<Components.Schemas.SystemVariableListItemSchema>,
        permissions: Set<String>,
        search: String?
    ) async throws -> HTMLResponse

    func renderErrorPage(
        title: String,
        message: String
    ) async throws -> HTMLResponse

}
