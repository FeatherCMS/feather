import AuthModule

extension Session.List.Interactor {
    struct Default: Interface {
        let repository: any Session.List.Repository.Interface

        func list(
            identityID: String
        ) async throws -> Session.List.Model {
            try await repository.search(identityID: identityID)
        }
    }
}
