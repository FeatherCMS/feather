import FeatherAdmin
import UserAdminAPI

protocol AdminListUserIdentityInteractor: Sendable {

    func list(
        page: Int,
        size: Int,
        search: String?,
        role: String?
    ) async throws -> AdminListModel<
        Components.Schemas.UserIdentityListItemSchema
    >
}
