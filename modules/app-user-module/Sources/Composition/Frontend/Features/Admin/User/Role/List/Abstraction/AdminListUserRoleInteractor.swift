import FeatherAdmin
import UserAdminAPI

protocol AdminListUserRoleInteractor: Sendable {

    func list(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> NewAdminListModel<
        Components.Schemas.UserRoleListItemSchema
    >
}
