import AdminOpenAPI
import Foundation

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

    func bulkRemove(
        ids: [String]
    ) async throws
}
