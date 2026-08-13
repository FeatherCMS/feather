import FeatherAdmin
import Foundation
import UserAdminAPI

protocol AdminListUserRoleRepository: Sendable {

    func list(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.UserRoleListItemSchema],
        total: Int,
        page: Int,
        size: Int
    )

    func delete(
        id: String
    ) async throws
}
