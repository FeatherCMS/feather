import AccountModule

extension Invitation.Add.Interactor {

    struct Default: Interface {
        let repository: any Invitation.Add.Repository.Interface

        func execute(
            entity: Invitation.Add.Model
        ) async throws {
            try await repository.create(payload: entity.payload)
        }
    }
}
