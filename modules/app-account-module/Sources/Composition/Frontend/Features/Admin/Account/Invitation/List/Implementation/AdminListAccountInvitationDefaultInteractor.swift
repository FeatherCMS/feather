import AccountAdminAPI
import FeatherAdmin
import Foundation
import Hummingbird

struct AdminListAccountInvitationDefaultInteractor:
    AdminListAccountInvitationInteractor
{
    let repository: any AdminListAccountInvitationRepository

    func execute(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.AccountInvitationListItemSchema], total: Int,
        page: Int, size: Int
    ) {
        try await repository.list(
            page: page,
            size: size,
            search: search
        )
    }

    func remove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
