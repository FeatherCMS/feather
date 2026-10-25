import AccountModule

extension Invitation.Edit.Interactor {

    struct Default: Interface {
        let repository: any Invitation.Edit.Repository.Interface

        func get(
            id: String
        ) async throws -> Invitation.Detail.Result {
            try await repository.get(id: id)
        }

        func execute(
            entity: Invitation.Edit.Model
        ) async throws {
            try await repository.update(id: entity.id, payload: entity.payload)
        }
    }
}
