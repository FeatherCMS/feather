import AdminOpenAPI
import Foundation
import Hummingbird

protocol AdminListUserInvitationRepository: Sendable {

    func list(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.UserInvitationListItemSchema],
        total: Int,
        page: Int,
        size: Int
    )

    func delete(
        id: String
    ) async throws
}
