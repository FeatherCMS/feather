import Foundation

struct AdminAddUserInvitationDefaultInteractor: AdminAddUserInvitationInteractor
{
    let repository: any AdminAddUserInvitationRepository

    func execute(
        entity: AdminAddUserInvitationModel
    ) async throws {
        try await repository.create(payload: entity.payload)
    }
}
