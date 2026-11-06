extension Login.Interactor {
    struct Default: Interface {
        let repository: any Login.Repository.Interface

        func execute(
            entity: Login.Model
        ) async throws -> Login.Result {
            try await repository.login(entity.command)
        }
    }
}
