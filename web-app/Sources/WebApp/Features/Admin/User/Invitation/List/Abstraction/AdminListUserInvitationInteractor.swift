import AdminOpenAPI
import Foundation

protocol AdminListUserInvitationInteractor: Sendable {

    func execute(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.UserInvitationListItemSchema],
        total: Int,
        page: Int,
        size: Int
    )

    func bulkRemove(
        ids: [String]
    ) async throws
}
