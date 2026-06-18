import Foundation

struct AdminGetUserInvitationDefaultInteractor:
    AdminGetUserInvitationInteractor
{
    let repository: any AdminGetUserInvitationRepository

    func execute(
        entity: AdminGetUserInvitationModel
    ) async throws -> UserInvitationDetailsModel {
        try await repository.get(id: entity.id)
    }
}
