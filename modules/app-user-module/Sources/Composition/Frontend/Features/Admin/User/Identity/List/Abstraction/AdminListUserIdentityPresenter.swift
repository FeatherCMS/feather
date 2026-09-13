import FeatherAdmin
import FeatherContracts
import Hummingbird
import UserAdminAPI

protocol AdminListUserIdentityPresenter: Sendable {
    func renderListPage(model: NewAdminListModel<Components.Schemas.UserIdentityListItemSchema>, permissions: Set<PermissionKey>, search: String?, role: String?) async throws -> HTMLResponse
    func renderErrorPage(error: AdminListUserIdentityError) async throws -> HTMLResponse
}
