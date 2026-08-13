import FeatherAdmin
import Foundation

struct AdminAddAccountInvitationDefaultInteractor:
    AdminAddAccountInvitationInteractor
{
    let repository: any AdminAddAccountInvitationRepository

    func execute(
        entity: AdminAddAccountInvitationModel
    ) async throws {
        try await repository.create(payload: entity.payload)
    }
}
