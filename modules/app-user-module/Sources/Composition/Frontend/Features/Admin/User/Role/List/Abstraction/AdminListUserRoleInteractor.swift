import FeatherAdmin
import Foundation
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
