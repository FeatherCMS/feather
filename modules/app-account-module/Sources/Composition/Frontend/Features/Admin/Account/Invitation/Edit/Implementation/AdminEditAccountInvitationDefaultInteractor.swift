import FeatherAdmin
import Foundation

struct AdminEditAccountInvitationDefaultInteractor:
    AdminEditAccountInvitationInteractor
{
    let repository: any AdminEditAccountInvitationRepository

    func get(
        id: String
    ) async throws -> AccountInvitationDetailsModel {
        try await repository.get(id: id)
    }

    func execute(
        entity: AdminEditAccountInvitationModel
    ) async throws {
        try await repository.update(id: entity.id, payload: entity.payload)
    }
}
