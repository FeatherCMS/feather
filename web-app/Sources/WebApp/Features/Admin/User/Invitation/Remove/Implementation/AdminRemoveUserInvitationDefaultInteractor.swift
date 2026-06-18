import Foundation

struct AdminRemoveUserInvitationDefaultInteractor:
    AdminRemoveUserInvitationInteractor
{
    let repository: any AdminRemoveUserInvitationRepository

    func get(
        id: String
    ) async throws -> UserInvitationDetailsModel {
        try await repository.get(id: id)
    }

    func execute(
        entity: AdminRemoveUserInvitationModel
    ) async throws {
        try await repository.delete(id: entity.id)
    }
}
