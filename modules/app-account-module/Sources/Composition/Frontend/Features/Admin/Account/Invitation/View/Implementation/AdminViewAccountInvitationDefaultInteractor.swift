struct AdminViewAccountInvitationDefaultInteractor:
    AdminViewAccountInvitationInteractor
{
    let repository: any AdminViewAccountInvitationRepository
    let roleNamesProvider: @Sendable ([String]) async -> [String]

    func roleNames(for ids: [String]) async -> [String] {
        await roleNamesProvider(ids)
    }

    func execute(
        entity: AdminViewAccountInvitationModel
    ) async throws -> AccountInvitationDetailsModel {
        try await repository.get(id: entity.id)
    }
}
