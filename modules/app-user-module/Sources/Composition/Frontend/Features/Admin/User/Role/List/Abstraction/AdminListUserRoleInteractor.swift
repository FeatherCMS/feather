import FeatherAdmin
import Foundation
import UserAdminAPI

protocol AdminListUserRoleInteractor: Sendable {

    func execute(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.UserRoleListItemSchema],
        total: Int,
        page: Int,
        size: Int
    )

    func remove(
        ids: [String]
    ) async throws
}
