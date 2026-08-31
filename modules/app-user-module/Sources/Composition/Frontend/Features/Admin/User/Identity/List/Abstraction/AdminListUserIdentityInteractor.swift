import FeatherAdmin
import Foundation
import UserAdminAPI

protocol AdminListUserIdentityInteractor: Sendable {

    func execute(
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

    func bulkRemove(
        ids: [String]
    ) async throws
}
