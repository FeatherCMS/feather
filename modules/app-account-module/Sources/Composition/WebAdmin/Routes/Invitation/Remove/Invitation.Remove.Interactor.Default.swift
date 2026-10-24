import AccountModule

extension Invitation.Remove.Interactor {

    struct Default:
        Invitation.Remove.Interactor.Interface
    {
        let repository: any Invitation.Remove.Repository.Interface

        func get(
            id: String
        ) async throws -> Invitation.Detail.Result {
            try await repository.get(id: id)
        }

        func execute(
            entity: Invitation.Remove.Model
        ) async throws {
            try await repository.delete(id: entity.id)
        }

        func execute(ids: [String]) async throws {
            for id in ids {
                try await repository.delete(id: id)
            }
        }
    }
}
