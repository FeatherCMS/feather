import AccountAdminAPI
import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminListAccountInvitationRepository: Sendable {

    func list(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.AccountInvitationListItemSchema],
        total: Int,
        page: Int,
        size: Int
    )

    func delete(
        id: String
    ) async throws
}
