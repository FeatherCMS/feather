import AdminOpenAPI
import Foundation

protocol AdminListUserAccountRepository: Sendable {

    func list(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.UserAccountListItemSchema],
        total: Int,
        page: Int,
        size: Int
    )

    func delete(
        id: String
    ) async throws
}
