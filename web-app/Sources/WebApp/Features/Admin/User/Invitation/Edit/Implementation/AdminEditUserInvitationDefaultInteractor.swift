import Foundation

struct AdminEditUserInvitationDefaultInteractor:
    AdminEditUserInvitationInteractor
{
    let repository: any AdminEditUserInvitationRepository

    func get(
        id: String
    ) async throws -> UserInvitationDetailsModel {
        try await repository.get(id: id)
    }

    func execute(
        entity: AdminEditUserInvitationModel
    ) async throws {
        try await repository.update(id: entity.id, payload: entity.payload)
    }
}
