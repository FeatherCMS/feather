import FeatherAdmin
import Foundation

struct AdminGetAccountInvitationDefaultInteractor:
    AdminGetAccountInvitationInteractor
{
    let repository: any AdminGetAccountInvitationRepository

    func execute(
        entity: AdminGetAccountInvitationModel
    ) async throws -> AccountInvitationDetailsModel {
        try await repository.get(id: entity.id)
    }
}
