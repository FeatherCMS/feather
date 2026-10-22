import AccountModule

extension Invitation.Detail.Interactor {

    struct Default:
        Invitation.Detail.Interactor.Interface
    {
        let repository: any Invitation.Detail.Repository.Interface
        let roleNamesProvider: @Sendable ([String]) async -> [String]

        func roleNames(for ids: [String]) async -> [String] {
            await roleNamesProvider(ids)
        }

        func execute(
            entity: Invitation.Detail.Model
        ) async throws -> AccountInvitationDetailsModel {
            try await repository.get(id: entity.id)
        }
    }
}
