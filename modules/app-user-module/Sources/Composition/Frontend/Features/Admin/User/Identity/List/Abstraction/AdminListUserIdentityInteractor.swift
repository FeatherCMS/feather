import FeatherAdmin
import Foundation
import UserAdminAPI

protocol AdminListUserIdentityInteractor: Sendable {

    func list(
        page: Int,
        size: Int,
        search: String?,
        role: String?
    ) async throws -> NewAdminListModel<Components.Schemas.UserIdentityListItemSchema>
}
