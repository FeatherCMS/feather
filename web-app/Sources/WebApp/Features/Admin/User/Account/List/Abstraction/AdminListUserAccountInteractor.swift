import AdminOpenAPI
import Foundation

protocol AdminListUserAccountInteractor: Sendable {

    func execute(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.UserAccountListItemSchema],
        total: Int,
        page: Int,
        size: Int
    )

    func bulkRemove(
        ids: [String]
    ) async throws
}
