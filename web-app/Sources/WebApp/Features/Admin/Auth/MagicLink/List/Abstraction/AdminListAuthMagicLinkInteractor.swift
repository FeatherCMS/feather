import AdminOpenAPI
import Foundation

protocol AdminListAuthMagicLinkInteractor: Sendable {

    func execute(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.UserMagicLinkListItemSchema],
        total: Int,
        page: Int,
        size: Int
    )

    func bulkRemove(
        ids: [String]
    ) async throws
}
