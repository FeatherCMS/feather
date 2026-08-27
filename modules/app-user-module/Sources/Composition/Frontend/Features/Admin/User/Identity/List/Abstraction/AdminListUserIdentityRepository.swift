import FeatherAdmin
import Foundation
import UserAdminAPI

protocol AdminListUserIdentityRepository: Sendable {

    func list(
        page: Int,
        size: Int,
        search: String?,
        role: String?
    ) async throws -> (
        items: [Components.Schemas.UserIdentityListItemSchema],
        total: Int,
        page: Int,
        size: Int
    )

    func delete(
        id: String
    ) async throws
}
