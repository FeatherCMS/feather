import FeatherAdmin
import Foundation

struct AdminGetAccountInvitationDefaultInteractor:
    AdminGetAccountInvitationInteractor
{
    let repository: any AdminGetAccountInvitationRepository
    let roleNamesProvider: @Sendable ([String]) async -> [String]

    func roleNames(for ids: [String]) async -> [String] {
        await roleNamesProvider(ids)
    }

    func execute(
        entity: AdminGetAccountInvitationModel
    ) async throws -> AccountInvitationDetailsModel {
        try await repository.get(id: entity.id)
    }
}
