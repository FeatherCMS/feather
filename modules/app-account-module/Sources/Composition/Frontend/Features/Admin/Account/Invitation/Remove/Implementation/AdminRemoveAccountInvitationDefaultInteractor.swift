import FeatherAdmin
import Foundation

struct AdminRemoveAccountInvitationDefaultInteractor:
    AdminRemoveAccountInvitationInteractor
{
    let repository: any AdminRemoveAccountInvitationRepository

    func get(
        id: String
    ) async throws -> AccountInvitationDetailsModel {
        try await repository.get(id: id)
    }

    func execute(
        entity: AdminRemoveAccountInvitationModel
    ) async throws {
        try await repository.delete(id: entity.id)
    }
}
