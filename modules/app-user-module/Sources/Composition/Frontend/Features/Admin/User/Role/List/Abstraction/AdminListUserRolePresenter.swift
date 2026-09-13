import FeatherAdmin
import FeatherContracts
import Hummingbird
import UserAdminAPI

protocol AdminListUserRolePresenter: Sendable {
    func renderListPage(model: NewAdminListModel<Components.Schemas.UserRoleListItemSchema>, permissions: Set<PermissionKey>, search: String?) async throws -> HTMLResponse
    func renderErrorPage(error: AdminListUserRoleError) async throws -> HTMLResponse
}
