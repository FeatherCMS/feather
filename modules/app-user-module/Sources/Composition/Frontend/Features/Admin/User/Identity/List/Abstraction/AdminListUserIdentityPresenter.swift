import FeatherAdmin
import FeatherModuleKit
import UserAdminAPI

protocol AdminListUserIdentityPresenter: Sendable {
    func renderListPage(
        model: AdminListModel<Components.Schemas.UserIdentityListItemSchema>,
        permissions: Set<PermissionKey>,
        search: String?,
        role: String?
    ) async throws -> HTMLResponse
    func renderErrorPage(error: AdminListUserIdentityError) async throws
        -> HTMLResponse
}
