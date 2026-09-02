import AccountAdminAPI
import FeatherAdmin
import Foundation

protocol AdminListAccountInvitationInteractor: Sendable {

    func execute(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.AccountInvitationListItemSchema],
        total: Int,
        page: Int,
        size: Int
    )

    func remove(
        ids: [String]
    ) async throws
}
