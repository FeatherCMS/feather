import FeatherAdmin
import FeatherContracts
import Hummingbird
import SystemAdminAPI

protocol AdminListSystemVariablePresenter: Sendable {

    func renderListPage(
        model: NewAdminListModel<
            Components.Schemas.SystemVariableListItemSchema
        >,
        permissions: Set<PermissionKey>,
        search: String?
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminListSystemVariableError
    ) async throws -> HTMLResponse

}
