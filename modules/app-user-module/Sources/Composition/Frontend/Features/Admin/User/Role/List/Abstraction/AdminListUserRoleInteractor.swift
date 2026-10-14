import FeatherAdmin
import UserAdminAPI

protocol AdminListUserRoleInteractor: Sendable {

    func list(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> AdminListModel<
        Components.Schemas.UserRoleListItemSchema
    >
}
